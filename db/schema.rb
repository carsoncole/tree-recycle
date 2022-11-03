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

ActiveRecord::Schema[7.0].define(version: 2022_11_03_191521) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "admin_zones", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "is_cancelled"
    t.boolean "is_confirmed"
    t.decimal "stripe_charge_amount"
    t.boolean "is_cash_or_check"
    t.decimal "latitude"
    t.decimal "longitude"
    t.boolean "is_picked_up"
    t.datetime "picked_up_at"
    t.bigint "zone_id"
    t.decimal "distance_to_zone"
    t.boolean "is_confirmation_email_sent"
    t.boolean "is_reminder_email_sent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_missing"
    t.datetime "is_missing_at"
    t.index ["zone_id"], name: "index_reservations_on_zone_id"
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
    t.boolean "is_emailing_enabled", default: false
    t.datetime "pickup_date_and_time"
    t.string "default_city"
    t.string "default_state"
    t.string "default_country", default: "United States"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sign_up_deadline_at"
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
  end

  add_foreign_key "logs", "reservations"
end
