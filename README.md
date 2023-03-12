# vitess-playground
Let's try Vitess by using it to scale an ecommerce app's database!

[![Ruby](https://github.com/mtantawy/vitess-playground/actions/workflows/ruby.yml/badge.svg)](https://github.com/mtantawy/vitess-playground/actions/workflows/ruby.yml)

## Plan
1. Build a simple headless ecommerce app
    * No authentication
    * No Admin-specific APIs
    * No real payments, emails, etc ...
2. Write set of `Commands` representing scenarios to be ran
    * CRUD Product
    * Search/List products
    * CRUD User
    * Add to cart
    * Update cart
    * Checkout
    * etc ...
3. Write parallelizable tasks to run the scenarios over and over
4. Push metrics for execution time
5. Visualize metrics over TICK-stack or similar
6. Increase rate of tasks being run until a database-bottleneck is hit
7. Start introducing Vitess as a proxy for unsharded database
8. Start sharding table(s) according to the bottleneck hit, while observing performance through metrics from #5
9. Iterate over #6 through #8

## Why Ruby? Why Rails?
For no major reason other than being tools I need to learn and get used to in my current job.

Also, RoR should allow faster development especially since the goal is not to develop a real product but to use a sample ecommerce app to basically cause a database-bottleneck and fake a need for scaling through sharding

## So what's Vitess?
Vitess is a way to horizontally scale a MySQL database while making little-to-no changes to the application.

Usually, sharding a database requires modifying the application to know which database(s) to reach out to when querying for record(s), this adds complexity to the application, mixing business/domain with infrastructure concerns and knowledge, the worst mix ever.

Vitess acts as a proxy that knows - through it's own schema - where to look for database record(s) when an application queries for them, it sits - almost - silently between the application and the databases, analyzing application queries and routing them quickly to the correct shard(s), and even sometimes merging results from multiple shards before presenting them to the application as results from one database.

In reality, Vitess is much more than a "proxy", this was an oversimplification that fits the purpose of this project.

In reality Vitess does a lot more like handling failovers, backups, replication, online schema changes (think gh-ost), even going as far as understanding availability zones or data centers to understand the topology of the underlying databases.

Read more at [vitess.io](https://vitess.io/)


## Updates/Changelog/Decision log

This section is going to be an append-only log of anything worthy documenting, like decisions, changes, or updates on progress

### 12.03.2023: Background jobs are now supported using Sidekiq and Redis
[Sidekiq](https://github.com/sidekiq/sidekiq) is now enabled and Redis has been added, this allows running jobs in the background using a proper queue adapter instead of the `async` adapter.

`worker` container has also been added which uses the same concurrency of 5 (read from `RAILS_MAX_THREADS`, `config/puma.rb`), and the container can be scaled up just like the `app` container, example: `docker compose up --scale worker=X --scale app=Y` (X, Y up to 10 due to configured port range)

Also now that we're using `rails` main branch we have access to the `perform_all_later` method that helps bulk enqueue jobs at once, example: `ActiveJob.perform_all_later(10.times.map { CreateProductJob.new })`

### 19.02.2023: Simple benchmarking for various cheap VPS providers to determine which to run the app on
Using the cheapest VPS available run a benchmark/stress-test using `ab` at 10K request with concurrency set to 3 to the `products/find` endpoint and observe the behaviour, specifically, how long does it take? what's the rate of requests? and whether the rate is smooth/consistent or fluctuates highly

Command: `ab -n 10000 -c 3 -l -m GET localhost:8080/products/find`

`-l` to ignore response size, otherwise different response sizes make `ab` report request to be a failure

**Digital Ocean**

Started with Digital Ocean because it is what I personally have been using for years and have familiarity with.

While setting up a VPS is smooth, the performance is not consistent, most probably due to shared-CPU and throttling, which is expected because shared-CPU VPS is not intended to sustain high performance/load, but rather low to medium load with non-persistent spikes of high load.

This is how it looked:![image](https://user-images.githubusercontent.com/244932/219951368-64b23ac2-c59f-42a3-9368-5f99d454c636.png)

**Linode**

Setup is smooth, VPS of same specs is like a dollar cheap.

Performace is worse though, had to increase `ab` timeout to 120 seconds.

This is how it looked:![image](https://user-images.githubusercontent.com/244932/219951810-3e4d545c-5583-4bb0-95e7-f46dbd5e3072.png)

**Hetzner**

Setup is okay, VPS os same specs is slightly cheaper too.

Performace is better as in, no throttling *observed*, rate of requests was lower but sustainable with makes more sense for this app to exclude external factors when observing the app and DB performance.

Here is how it looked:![image](https://user-images.githubusercontent.com/244932/219952038-d351860d-758e-4ac4-b676-1d760906727e.png)

**Binary Racks**

Setup is okay, while they don't offer all bells and whistles you'd expect, they're much cheaper.

Performance is much better, no throttling *observed* as well, rate of requests was proportionally good and rate of requests was stable

Using a 2-CPU VPS I was able to run 3 app containers, and benchmark at 100K requests with 15 concurrent requests and get very good results

This is how it looked:![image](https://user-images.githubusercontent.com/244932/219952203-161258ca-1045-4cf2-aedb-93abaa9ce399.png)

**Conclusion**

It appears that less-known providers are able to provide more stable CPU power without much throttling probably due to not being super popular and having lots of users competing on resources, also cheaper so one can get more value-for-money.

As it stands, I'll most probably use a mix of Hetzner and Binary Racks, will report back if observed performance changes.


### 02.02.2023: How to run the app and its dependencies on 1 machine, from scratch
This is how the setup should look like, ignoring the server specs
![image](https://user-images.githubusercontent.com/244932/216458030-25544604-7874-47af-9694-330e51b0a840.png)

Given an Ubuntu machine, these are the steps to run the app and all its components/dependencies
1. [Create a non-`root` user and grant them `sudo` privileges](https://www.digitalocean.com/community/tutorials/how-to-add-and-delete-users-on-ubuntu-20-04)
2. Add personal SSH key to the new user & optionally add an entry for the new server at `/etc/hosts` for quicker access (vs IP)
3. [Install the Docker Engine using the repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
4. Follow up with the [Linux post-install steps](https://docs.docker.com/engine/install/linux-postinstall/)
5. (Optionally) [Configure `swap` in case the server's memory is less than 1GB](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-20-04)
6. [Add the new server's SSH key to GitHub to allow cloning using SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
7. Clone the repo
8. Run `docker compose run -it app bash` to access the `app` container without running the app, delete `config/credentials.yml.enc` (we don't care because there are no encrypted secrets), then run `bin/rails credentials:edit` as per [the guide](https://edgeguides.rubyonrails.org/security.html) to regenerate credentials and master key.
9. Next step is to setup InfluxDB to obtain a token, run `docker compose up` and ignore warnings about wrong/missing token, access Influxdb UI (note the port from nginx configs), create an admin account, go to tokens and create one with permissions only to read and write to the newly-created bucket during account setup, copy `.env.sample` to `.env` and append the obtained InfluxDB token, finally, stop the containers and run `docker compose up --build` to ensure environment variable is read from the `.env` file, all related errors/warnings should be gone!
10. Confirm all is good by running few `curl` requests to create DB records and read them back, also test `bin/rails c` in an `app` container, finally verify metrics are being pushed to InfluxDB's correct bucket
11. Install `ab` to stress test by sending HTTP requests using `sudo apt install apache2-utils`
12. (Optionally) Install `telegraf` on the host to get cpu/mem/desk/deskio/etc ... metrics to the same InfluxDB bucket, all what's needed is to modify `telegraf`'s config file and comment/uncomment needed `Inputs`/`Outputs`, will also need to pass InfluxDB token either through env vars or by hardcoding it to the config file.

### 24.01.2023: This is not an update, but rather an issue that I waste a lot of time on whenever it occurs
When updating one of the dependencies, I probably need to purge Bootsnap's cache, otherwise the app doesn't run in docker even if it runs out of docker correctly, errors are usually about failing to load a file or a dependency.

> Note also that bootsnap will never clean up its own cache: this is left up to you. Depending on your deployment strategy, you may need to periodically purge tmp/cache/bootsnap*. If you notice deploys getting progressively slower, this is almost certainly the cause.

From https://github.com/Shopify/bootsnap/#usage

### 13.09.2022: Write the scenarios as `jobs` so they could be triggered `async` as application jobs or `sync` through controllers
I was initially going to make the component stress-loading the application to be async jobs running through rails, but then thought that it'd be slow and re-inventing the wheel vs using existing tools that can be configured to shoot http requests to the application.

The second decision is to make the actual code of a `scenario` in a `job` so that it could be re-used, basically allowing testing it as a job without having to call a controller or make an http request, this also allows me to setup rails jobs as a first step before setting up proper `loaders` that shoot http requests.

### 13.09.2022: Push metrics directly to `influxdb` instead of `telegraf` then `influxdb` for simplicity
I basically found this tutorial https://www.influxdata.com/blog/monitoring-ruby-on-rails-with-influxdb/ and a seemingly well-maintained gem https://github.com/influxdata/influxdb-client-ruby, so for the sake of simplicity I am going to follow that until there is a reason to push to `telegraf` at which point I will probably use https://github.com/jgraichen/telegraf-ruby .
