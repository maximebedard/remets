# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160202021721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "authorizations", force: :cascade do |t|
    t.integer "user_id"
    t.string  "provider"
    t.string  "uid"
    t.string  "token"
    t.string  "secret"
  end

  create_table "boilerplate_documents", force: :cascade do |t|
    t.integer  "handover_id"
    t.string   "file_ptr"
    t.string   "file_secure_token"
    t.string   "file_original_name"
    t.integer  "fingerprints",       default: [], null: false, array: true
    t.integer  "indexes",            default: [], null: false, array: true
    t.datetime "fingerprinted_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "boilerplate_documents", ["fingerprints"], name: "index_boilerplate_documents_on_fingerprints", using: :gin

  create_table "document_matches", force: :cascade do |t|
    t.integer  "reference_document_id"
    t.integer  "compared_document_id"
    t.integer  "match_id"
    t.float    "similarity"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "documents", force: :cascade do |t|
    t.integer  "submission_id"
    t.string   "file_ptr"
    t.string   "file_secure_token"
    t.string   "file_original_name"
    t.integer  "fingerprints",       default: [], null: false, array: true
    t.integer  "indexes",            default: [], null: false, array: true
    t.datetime "fingerprinted_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "documents", ["fingerprints"], name: "index_documents_on_fingerprints", using: :gin

  create_table "handovers", force: :cascade do |t|
    t.uuid     "uuid",            default: "uuid_generate_v4()"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "invite_only",     default: true
    t.string   "password_digest"
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "fingerprints", default: [], null: false, array: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string  "name",    null: false
    t.integer "user_id", null: false
  end

  create_table "reference_documents", force: :cascade do |t|
    t.integer  "handover_id"
    t.string   "file_ptr"
    t.string   "file_secure_token"
    t.string   "file_original_name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "handover_id"
  end

  create_table "user_organizations", force: :cascade do |t|
    t.integer "user_id",         null: false
    t.integer "organization_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest",                  null: false
    t.string "remember_digest"
    t.string "email",                            null: false
    t.string "role",            default: "user", null: false
  end

end
