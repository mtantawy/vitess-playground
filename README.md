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

### 24.01.2023: This is not an update, but rather an issue that I waste a lot of time on whenever it occurs
When updating one of the dependencies, I probably need to purge Bootsnap's cache, otherwise the app doesn't run in docker even if it runs out of docker correctly, errors are usually about failing to load a file or a dependency.

> Note also that bootsnap will never clean up its own cache: this is left up to you. Depending on your deployment strategy, you may need to periodically purge tmp/cache/bootsnap*. If you notice deploys getting progressively slower, this is almost certainly the cause.

From https://github.com/Shopify/bootsnap/#usage

### 13.09.2022: Write the scenarios as `jobs` so they could be triggered `async` as application jobs or `sync` through controllers
I was initially going to make the component stress-loading the application to be async jobs running through rails, but then thought that it'd be slow and re-inventing the wheel vs using existing tools that can be configured to shoot http requests to the application.

The second decision is to make the actual code of a `scenario` in a `job` so that it could be re-used, basically allowing testing it as a job without having to call a controller or make an http request, this also allows me to setup rails jobs as a first step before setting up proper `loaders` that shoot http requests.

### 13.09.2022: Push metrics directly to `influxdb` instead of `telegraf` then `influxdb` for simplicity
I basically found this tutorial https://www.influxdata.com/blog/monitoring-ruby-on-rails-with-influxdb/ and a seemingly well-maintained gem https://github.com/influxdata/influxdb-client-ruby, so for the sake of simplicity I am going to follow that until there is a reason to push to `telegraf` at which point I will probably use https://github.com/jgraichen/telegraf-ruby .
