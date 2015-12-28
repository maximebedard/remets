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

ActiveRecord::Schema.define(version: 20150926225705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "document_matches", force: :cascade do |t|
    t.integer "reference_document_id"
    t.integer "compared_document_id"
    t.integer "fingerprints",          default: [], array: true
  end

  create_table "documents", force: :cascade do |t|
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.string   "file_ptr"
    t.integer  "fingerprints",      default: [], null: false, array: true
    t.integer  "indexes",           default: [], null: false, array: true
    t.datetime "fingerprinted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id", using: :btree
  add_index "documents", ["fingerprints"], name: "index_documents_on_fingerprints", using: :gin

  create_table "handovers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "handover_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.string "name"
    t.string "email"
  end

end
