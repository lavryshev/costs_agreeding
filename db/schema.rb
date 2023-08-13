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

ActiveRecord::Schema[7.0].define(version: 2023_08_13_075314) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expenses", force: :cascade do |t|
    t.integer "status", default: 0
    t.decimal "sum", precision: 15, scale: 2, null: false
    t.datetime "payment_date"
    t.bigint "responsible_id"
    t.text "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "source_id", null: false
    t.bigint "external_app_id", null: false
    t.string "external_id", null: false
    t.index ["external_app_id"], name: "index_expenses_on_external_app_id"
    t.index ["responsible_id"], name: "index_expenses_on_responsible_id"
    t.index ["source_id"], name: "index_expenses_on_source_id"
    t.index ["status"], name: "index_expenses_on_status"
  end

  create_table "external_apps", force: :cascade do |t|
    t.string "name", null: false
    t.text "token"
    t.boolean "active", default: true
    t.string "callback_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_external_apps_on_token", unique: true
  end

  create_table "service_tasks", force: :cascade do |t|
    t.string "action", null: false
    t.jsonb "data", default: "{}", null: false
    t.bigint "external_app_id", null: false
    t.index ["external_app_id"], name: "index_service_tasks_on_external_app_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name", null: false
    t.string "externalid", null: false
    t.index ["externalid"], name: "index_sources_on_externalid", unique: true
  end

  create_table "status_changed_reports", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "responsible_id", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_status_changed_reports_on_expense_id"
    t.index ["responsible_id"], name: "index_status_changed_reports_on_responsible_id"
    t.index ["status"], name: "index_status_changed_reports_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "login", null: false
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
    t.string "perishable_token"
    t.boolean "is_admin", default: false
    t.boolean "can_agree", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["perishable_token"], name: "index_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_users_on_persistence_token", unique: true
  end

  add_foreign_key "expenses", "external_apps"
  add_foreign_key "expenses", "sources"
  add_foreign_key "expenses", "users", column: "responsible_id"
  add_foreign_key "service_tasks", "external_apps"
  add_foreign_key "status_changed_reports", "expenses"
  add_foreign_key "status_changed_reports", "users", column: "responsible_id"
end
