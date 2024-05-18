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

ActiveRecord::Schema[7.0].define(version: 2024_04_28_222211) do
  create_table "collection_items", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "collection_id"
    t.index ["collection_id"], name: "index_collection_items_on_collection_id"
  end

  create_table "collection_type_actions", force: :cascade do |t|
    t.json "metadata"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "\"collection_type_id\"", name: "index_collection_type_actions_on_collection_type_id"
  end

  create_table "collection_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "actions"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "collection_type_id"
    t.integer "creator_id"
    t.index ["collection_type_id"], name: "index_collections_on_collection_type_id"
    t.index ["creator_id"], name: "index_collections_on_creator_id"
  end

  create_table "user_collection_items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "collection_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_item_id"], name: "index_user_collection_items_on_collection_item_id"
    t.index ["user_id"], name: "index_user_collection_items_on_user_id"
  end

  create_table "user_collections", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_user_collections_on_collection_id"
    t.index ["user_id"], name: "index_user_collections_on_user_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collection_items", "collections"
  add_foreign_key "collections", "collection_types"
  add_foreign_key "collections", "users", column: "creator_id"
  add_foreign_key "user_collection_items", "collection_items"
  add_foreign_key "user_collection_items", "users"
  add_foreign_key "user_collections", "collections"
  add_foreign_key "user_collections", "users"
end
