# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_02_101721) do

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "xero_contact_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "status"
    t.string "payment_status"
    t.float "amount"
    t.float "paid_amount"
    t.date "issue_date"
    t.date "due_date"
    t.integer "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "xero_invoice_id"
    t.index ["client_id"], name: "index_invoices_on_client_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.float "unit_amount"
    t.integer "quantity"
    t.date "date"
    t.string "description"
    t.integer "invoice_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["invoice_id"], name: "index_transactions_on_invoice_id"
  end

  add_foreign_key "invoices", "clients"
  add_foreign_key "transactions", "invoices"
end
