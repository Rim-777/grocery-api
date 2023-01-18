## Grocery API
Ruby-on-Rails [JSON:API](https://jsonapi.org/) application with ActiveRecord, [Dry-rb](https://dry-rb.org/), RSpec, Swagger
### Dependencies:
- Ruby 2.7.6
- PostgreSQL

### Installation:
- Clone poject
- Run bundler:

 ```shell
 $ bundle install
 ```
- Copy database.yml:
```shell
$ cp config/database.yml.sample config/database.yml
```

- Create and migrate database:

```shell
 $ bundle exec rails db:create
 $ bundle exec rails db:migrate
```
- Run application:

 ```shell
 $ rails server
 ```

##### Tests:
To execute automation tests, run following commands:

```shell
 $ bundle exec rake db:migrate RAILS_ENV=test #(the first time only)
 $ bundle exec rspec
```

### Explanation of the approach:
DDD Service-based modular app design with step-based processes. 
All business logic resides in the abstraction named operations(no business logic in models or controllers)

#### Common logic:
The first edition that allows users to add products to a shopping cart and get bonuses and discounts.
#####
Detailed swagger documentation on http://localhost:3000/api-docs
#####
For playing around it can be used as a UI, to make it possible and 
populate some list of products and related actions please run: 
```shell
$ bundle exec rails db:seed
```


### License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).