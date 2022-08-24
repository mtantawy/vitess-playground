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
