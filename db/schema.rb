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

ActiveRecord::Schema[8.0].define(version: 2025_03_07_230156) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "chefs", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone_number", null: false
    t.integer "age", null: false
    t.integer "salary", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_chefs_on_category_id"
    t.index ["email"], name: "index_chefs_on_email", unique: true
    t.index ["jti"], name: "index_chefs_on_jti"
    t.index ["reset_password_token"], name: "index_chefs_on_reset_password_token", unique: true
  end

  create_table "completed_orders", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "user_id", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "completed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_completed_orders_on_order_id"
    t.index ["user_id"], name: "index_completed_orders_on_user_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.index ["category_id"], name: "index_foods_on_category_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.bigint "food_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_ingredients_on_food_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "food_id", null: false
    t.bigint "order_id", null: false
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chef_id", null: false
    t.string "status"
    t.index ["chef_id"], name: "index_order_items_on_chef_id"
    t.index ["food_id"], name: "index_order_items_on_food_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "order_time"
    t.string "order_status"
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone_number", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["jti"], name: "index_owners_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "table_id", null: false
    t.datetime "booked_from", null: false
    t.datetime "booked_to", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booked_from", "booked_to"], name: "index_reservations_on_booked_from_and_booked_to"
    t.index ["table_id"], name: "index_reservations_on_table_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "num_of_seats", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "table_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chefs", "categories", on_delete: :cascade
  add_foreign_key "completed_orders", "orders"
  add_foreign_key "completed_orders", "users"
  add_foreign_key "foods", "categories", on_delete: :cascade
  add_foreign_key "ingredients", "foods", on_delete: :cascade
  add_foreign_key "order_items", "chefs"
  add_foreign_key "order_items", "foods", on_delete: :cascade
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "reservations", "tables"
  add_foreign_key "reservations", "users"
end
