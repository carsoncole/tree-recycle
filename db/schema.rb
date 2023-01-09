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

ActiveRecord::Schema[7.0].define(version: 2023_01_09_221849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

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
    t.string "stripe_payment_intent_id"
    t.string "customer_name"
    t.string "checkout_session_status"
    t.string "checkout_session_customer_email"
    t.string "payment_intent_id"
    t.string "description"
    t.string "last4"
    t.string "exp_month"
    t.string "exp_year"
    t.integer "form"
    t.string "note"
    t.index ["reservation_id"], name: "index_donations_on_reservation_id"
  end

  create_table "driver_routes", force: :cascade do |t|
    t.bigint "driver_id"
    t.bigint "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_driver_routes_on_driver_id"
    t.index ["route_id"], name: "index_driver_routes_on_route_id"
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

  create_table "messages", force: :cascade do |t|
    t.string "phone"
    t.string "body"
    t.uuid "reservation_id"
    t.string "service_status"
    t.integer "direction"
    t.boolean "viewed", default: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone"], name: "index_messages_on_phone"
  end

  create_table "points", force: :cascade do |t|
    t.bigint "route_id", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0
    t.index ["route_id"], name: "index_points_on_route_id"
  end

  create_table "remind_mes", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.decimal "latitude"
    t.decimal "longitude"
    t.bigint "route_id"
    t.decimal "distance_to_route"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.boolean "no_emails", default: false
    t.string "route_name"
    t.boolean "is_routed", default: true
    t.integer "heard_about_source"
    t.string "unit"
    t.boolean "no_sms", default: false
    t.integer "donation"
    t.boolean "is_confirmed_reservation_email_sent", default: false
    t.boolean "is_marketing_email_1_sent", default: false
    t.boolean "is_marketing_email_2_sent", default: false
    t.boolean "is_geocoded", default: true
    t.boolean "is_door_hanger"
    t.integer "collected"
    t.decimal "collected_amount"
    t.boolean "is_route_polygon", default: false
    t.boolean "is_pickup_reminder_email_sent", default: false
    t.string "admin_notes"
    t.integer "years_recycling", default: 1
    t.index ["email"], name: "index_reservations_on_email"
    t.index ["name"], name: "index_reservations_on_name"
    t.index ["phone", "status"], name: "index_reservations_on_phone_and_status"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "driver_secret_key"
    t.string "facebook_page_id"
    t.string "meta_site_name"
    t.string "meta_title"
    t.string "meta_description"
    t.string "meta_image_filename"
    t.string "reservations_closed_message"
    t.boolean "is_driver_site_enabled", default: true
    t.integer "email_batch_quantity", default: 300
    t.text "driver_instructions"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "phone"
    t.integer "role", default: 0, null: false
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
  add_foreign_key "points", "routes"
end
