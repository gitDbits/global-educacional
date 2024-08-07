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

ActiveRecord::Schema[7.0].define(version: 2024_07_12_173045) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "duration"
    t.float "value"
    t.boolean "open_subscription"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.datetime "start_event_day"
    t.datetime "end_event_day"
    t.string "slug"
    t.string "announcer"
    t.index ["slug"], name: "index_events_on_slug", unique: true
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "fantasy_name"
    t.string "abbreviation"
    t.string "cnpj"
    t.string "phone"
    t.string "address"
    t.string "number_addres"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "complement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "state_ufs", force: :cascade do |t|
    t.string "abbreviation"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "abbreviation"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.string "payment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_status"
    t.text "paid_note"
    t.index ["event_id"], name: "index_subscription_events_on_event_id"
    t.index ["user_id"], name: "index_subscription_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "cpf"
    t.string "phone"
    t.string "zipcode"
    t.string "address"
    t.string "number_address"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "complement_address"
    t.boolean "admin"
    t.string "payment_method"
    t.boolean "paid"
    t.text "paid_note"
    t.string "payment_status"
    t.string "institution"
    t.string "slug"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "subscription_events", "events"
  add_foreign_key "subscription_events", "users"
end
