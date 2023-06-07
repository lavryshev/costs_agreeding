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

ActiveRecord::Schema[7.0].define(version: 2023_05_08_183635) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "cashboxes", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "expense_statuses", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "status_id"
    t.string "source_type"
    t.bigint "source_id"
    t.decimal "sum", precision: 15, scale: 2, null: false
    t.datetime "payment_date"
    t.bigint "author_id", null: false
    t.bigint "responsible_id"
    t.text "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_expenses_on_author_id"
    t.index ["responsible_id"], name: "index_expenses_on_responsible_id"
    t.index ["source_type", "source_id"], name: "index_expenses_on_source"
    t.index ["status_id"], name: "index_expenses_on_status_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "login"
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
    t.string "perishable_token"
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["perishable_token"], name: "index_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_users_on_persistence_token", unique: true
  end

  add_foreign_key "expenses", "expense_statuses", column: "status_id"
  add_foreign_key "expenses", "users", column: "author_id"
  add_foreign_key "expenses", "users", column: "responsible_id"
end
