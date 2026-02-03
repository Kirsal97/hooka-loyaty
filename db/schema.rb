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

ActiveRecord::Schema[8.1].define(version: 2026_02_03_153004) do
  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "phone", null: false
    t.datetime "updated_at", null: false
    t.index ["phone"], name: "index_clients_on_phone", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name", default: "", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_employees_on_email_address", unique: true
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.integer "employee_id", null: false
    t.boolean "is_reward", default: false, null: false
    t.string "note"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_purchases_on_client_id"
    t.index ["employee_id"], name: "index_purchases_on_employee_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "employee_id", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["employee_id"], name: "index_sessions_on_employee_id"
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  add_foreign_key "purchases", "clients"
  add_foreign_key "purchases", "employees"
  add_foreign_key "sessions", "employees"
end
