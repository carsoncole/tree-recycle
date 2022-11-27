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

ActiveRecord::Schema[7.0].define(version: 2022_11_27_002510) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "donations", force: :cascade do |t|
    t.uuid "reservation_id"
    t.string "checkout_session_id"
    t.decimal "amount", default: "0.0"
    t.string "status"
    t.string "payment_status"
    t.string "receipt_url"
    t.string "email"
    t.boolean "is_receipt_email_sent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_donations_on_reservation_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.bigint "zone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_leader"
    t.index ["zone_id"], name: "index_drivers_on_zone_id"
  end

  create_table "logs", force: :cascade do |t|
    t.uuid "reservation_id", null: false
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_logs_on_reservation_id"
  end

  create_table "reservations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "street"
    t.string "house_number"
    t.string "street_name"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country", default: "United States"
    t.string "notes"
    t.decimal "stripe_charge_amount"
    t.boolean "is_cash_or_check"
    t.decimal "latitude"
    t.decimal "longitude"
    t.bigint "route_id"
    t.decimal "distance_to_route"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.boolean "no_emails"
    t.string "route_name"
    t.boolean "is_routed", default: true
    t.integer "heard_about_source"
    t.string "unit"
    t.index ["name"], name: "index_reservations_on_name"
    t.index ["route_id"], name: "index_reservations_on_route_id"
    t.index ["status", "route_id"], name: "index_reservations_on_status_and_route_id"
    t.index ["status"], name: "index_reservations_on_status"
    t.index ["street"], name: "index_reservations_on_street"
    t.index ["street_name", "house_number"], name: "index_reservations_on_street_name_and_house_number"
  end

  create_table "routes", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "country"
    t.boolean "use_street_name"
    t.decimal "distance"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zone_id"
    t.decimal "distance_to_zone"
    t.string "house_number"
    t.string "street_name"
    t.boolean "is_zoned", default: true
    t.index ["name"], name: "index_routes_on_name"
  end

  create_table "settings", force: :cascade do |t|
    t.string "site_title"
    t.text "site_description"
    t.string "organization_name"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.text "description"
    t.text "on_day_of_pickup_instructions"
    t.boolean "is_reservations_open", default: true
    t.boolean "is_emailing_enabled", default: true
    t.datetime "pickup_date_and_time"
    t.string "default_city"
    t.string "default_state"
    t.string "default_country", default: "United States"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sign_up_deadline_at"
    t.datetime "pickup_date_and_end_time"
    t.string "driver_secret_key"
    t.string "sms_from_phone"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

  create_table "zones", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "country"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "house_number"
    t.string "street_name"
    t.index ["name"], name: "index_zones_on_name"
  end

  add_foreign_key "donations", "reservations"
  add_foreign_key "logs", "reservations"
end
