# TeaSubscriber - Project README
# Back-End

## Setup

- Ruby 3.2.2
- Rails 7.08 
- [JSONAPI Serializer](https://github.com/jsonapi-serializer/jsonapi-serializer) 
- [SimpleCov](https://github.com/simplecov-ruby/simplecov) 
- [ShouldaMatchers](https://github.com/thoughtbot/shoulda-matchers) 

## Installation Instructions
 - Fork Repository
 - `git clone <repo_name>`
 - `cd <repo_name>`
 - `bundle install`   
 - `rails db:{drop,create,migrate,seed}`
 - `rails s`

## Project Description

**TeaSubscriber** is a practice back-end API which simulates subscribing to a tea subscription service.  This application utilizes SOA; therefore, this API only handles the subscription aspect of the application, not the user and the tea product portion.

## Database Schema
```
  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "title"
    t.float "price"
    t.integer "status"
    t.integer "frequency"
    t.bigint "customer_id", null: false
    t.bigint "tea_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["tea_id"], name: "index_subscriptions_on_tea_id"
  end

  create_table "teas", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "temperature"
    t.integer "brew_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "teas"
  ```

  ## Endpoints

`POST /api/v1/subscriptions`

In order to subscribe a customer to a new tea, the front end application will need to pass through the following parameters:
-title
-price
-status
-frequency
-customer_id
-tea_id

`PATCH /api/v1/subscriptions/#{subscription.id}`

In order for a customer to cancel their tea subscription, the front end application will need to pass through the following parameters:
-subscription.id
-updated status (cancelled)

`GET /api/v1/subscriptions?customer_id={customer.id}`

In order to view all active and cancelled subscriptions of a customer, the front end application will need to pass through the following paramters:
-customer_id

  ## Contributors

- [Nicholas McEnroe](https://www.linkedin.com/in/nicholasmcenroe/) - GitHub: [@NSMcEnroe](https://github.com/NSMcEnroe)

