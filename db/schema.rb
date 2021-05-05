# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_02_184914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "api_specs", force: :cascade do |t|
    t.jsonb "spec"
    t.integer "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "commit_message"
    t.string "branch"
    t.string "author"
    t.string "commit_url"
  end

  create_table "personal_data", force: :cascade do |t|
    t.string "name"
    t.integer "lawful_basis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purposes", force: :cascade do |t|
    t.string "name"
    t.string "parent_prupose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_connections", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "service_id"
    t.integer "direction", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "gitlab_repo_url"
    t.boolean "internal"
    t.integer "service_provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "git_http_url"
    t.boolean "ignore"
  end

  create_table "utilizers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "city"
    t.string "plz"
    t.string "street"
    t.string "house_number"
    t.string "country"
    t.string "phone"
    t.string "fax"
    t.string "website"
    t.string "privacy_notice_url"
    t.string "open_api_names", array: true
    t.string "parent_utilizer"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
