# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_05_004445) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "nickname"
    t.string "street_address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.boolean "is_default", default: false
    t.datetime "last_used_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "delivery_at", null: false
    t.integer "headcount", null: false
    t.string "status", default: "pending", null: false
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "delivery_fee", precision: 10, scale: 2
    t.decimal "tax_amount", precision: 10, scale: 2
    t.decimal "total_amount", precision: 10, scale: 2
    t.text "special_instructions"
    t.bigint "user_id", null: false
    t.bigint "restaurant_id", null: false
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "address"
    t.string "phone_number"
    t.string "image_url"
    t.decimal "minimum_order_amount", precision: 10, scale: 2
    t.decimal "delivery_fee", precision: 10, scale: 2
    t.float "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saved_restaurants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_saved_restaurants_on_restaurant_id"
    t.index ["user_id"], name: "index_saved_restaurants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "orders", "users"
  add_foreign_key "saved_restaurants", "restaurants"
  add_foreign_key "saved_restaurants", "users"
end
