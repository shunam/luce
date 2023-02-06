Luce backend hiring assignment

A full stack Ruby on Rails app.

Ruby version: 3.0.0
Rails version: 6.0.4

The app manages invoices for clients.
Each client can have multiple invoices. Each invoice can have multiple transactions. The invoice amount to be paid is derived from the transactions attached to an invoice.

- Invoices are generated automatically via a cron job that is run every 7 days. (rake task: generate_invoices)
- Invoice can have 3 statuses: NEW, CONFIRMED, & CANCELLED
- Invoice can also store the value of paid_amount along with payment_status as UNPAID, UNDERPAID, PAID. But the app currently does have a mechanism to apply a payment or keep track of it.
- Invoice amount value is the sum of amounts for each attached transaction. Although the sync between invoice.amount and its trasactions is not real time. The `invoice.amount` value has to be updated explicitly whenever its trasactions are modified.
- Relevant methods/controller actions on Invoice:
  - confirm
  - cancel
  - compute_amount
- The transaction amount is calculated as: unit_value * quantity
- Use the `seeds.rb` file to create some clients.

# The UI
- There is some UI which helps manage all the data.

# How to run the app locally
- `cd` into the project directory
- `bundle install`
- `rails db:setup`
- `rails db:seed`
- `rails server`
