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
Detailed swagger documentation on the [localhost](http://localhost:3000/api-docs) and [the deployed version](https://groceryapi.herokuapp.com/api-docs/index.html)
#####
For playing with the APP around you can use swagger docs UI. 
#####
Please note to make it possible on the [localhost](http://localhost:3000/api-docs) you should
populate some list of products and related actions by running the following command: 

```shell
$ bundle exec rails db:seed
```

#### Closest tasks to do:
1) Add users association
2) Add uses authentication
3) Add functionality for removing products from shopping carts

### License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).