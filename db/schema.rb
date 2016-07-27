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

ActiveRecord::Schema.define(version: 0) do

  create_table "arguments", force: :cascade do |t|
    t.string "name", limit: 30
  end

  create_table "arguments_seminars", id: false, force: :cascade do |t|
    t.integer "argument_id", limit: 4, null: false
    t.integer "seminar_id",  limit: 4, null: false
  end

  add_index "arguments_seminars", ["argument_id"], name: "argument_id", using: :btree
  add_index "arguments_seminars", ["seminar_id"], name: "seminar_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 200
  end

  create_table "cycles", force: :cascade do |t|
    t.integer "user_id",     limit: 4
    t.string  "title",       limit: 250
    t.text    "description", limit: 65535
    t.string  "committee",   limit: 250
    t.string  "link",        limit: 250
    t.boolean "active"
  end

  add_index "cycles", ["user_id"], name: "user_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "seminar_id",          limit: 4
    t.integer  "repayment_id",        limit: 4
    t.string   "description",         limit: 200
    t.datetime "created_at"
    t.string   "attach_file_name",    limit: 200
    t.string   "attach_content_type", limit: 100
    t.integer  "attach_file_size",    limit: 4
    t.datetime "attach_updated_at"
  end

  add_index "documents", ["repayment_id"], name: "repayment_id", using: :btree
  add_index "documents", ["seminar_id"], name: "seminar_id", using: :btree
  add_index "documents", ["user_id"], name: "user_id", using: :btree

  create_table "funds", force: :cascade do |t|
    t.string  "name",        limit: 200
    t.string  "description", limit: 255
    t.integer "category_id", limit: 4,   null: false
    t.integer "holder_id",   limit: 4,   null: false
    t.date    "deadline"
    t.boolean "available"
    t.string  "code",        limit: 50
  end

  add_index "funds", ["holder_id"], name: "holder_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.text "name", limit: 65535
  end

  create_table "repayments", force: :cascade do |t|
    t.integer "seminar_id",        limit: 4,                           null: false
    t.integer "holder_id",         limit: 4,                           null: false
    t.integer "fund_id",           limit: 4
    t.string  "name",              limit: 255
    t.string  "surname",           limit: 255
    t.string  "email",             limit: 255
    t.string  "address",           limit: 255
    t.string  "postalcode",        limit: 255
    t.string  "city",              limit: 255
    t.string  "country",           limit: 255
    t.boolean "italy"
    t.string  "birth_date",        limit: 255
    t.string  "birth_place",       limit: 255
    t.string  "birth_country",     limit: 255
    t.date    "speaker_arrival"
    t.date    "speaker_departure"
    t.string  "affiliation",       limit: 255
    t.decimal "payment",                       precision: 8, scale: 2
    t.boolean "gross"
    t.string  "role",              limit: 255
    t.boolean "refund"
    t.integer "expected_refund",   limit: 4
    t.boolean "notified"
  end

  add_index "repayments", ["fund_id"], name: "fund_id", using: :btree
  add_index "repayments", ["holder_id"], name: "index_repayments_on_holder_id", using: :btree
  add_index "repayments", ["seminar_id"], name: "index_repayments_on_seminar_id", using: :btree

  create_table "seminars", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.datetime "date"
    t.integer  "duration",          limit: 4
    t.integer  "place_id",          limit: 4
    t.text     "place_description", limit: 65535
    t.string   "speaker",           limit: 250
    t.string   "speaker_title",     limit: 20
    t.string   "committee",         limit: 200
    t.string   "title",             limit: 250
    t.text     "abstract",          limit: 65535
    t.string   "file",              limit: 200
    t.string   "link",              limit: 250
    t.string   "link_text",         limit: 255
    t.string   "alert_message",     limit: 255
    t.datetime "alert_deadline"
    t.integer  "serial_id",         limit: 4
    t.integer  "cycle_id",          limit: 4
  end

  add_index "seminars", ["cycle_id"], name: "index_seminars_on_cycle_id", using: :btree
  add_index "seminars", ["serial_id"], name: "index_seminars_on_serial_id", using: :btree
  add_index "seminars", ["user_id"], name: "index_seminars_on_user_id", using: :btree

  create_table "serials", force: :cascade do |t|
    t.string  "title",       limit: 250
    t.text    "description", limit: 65535
    t.string  "committee",   limit: 250
    t.string  "link",        limit: 250
    t.boolean "active"
  end

  create_table "users", force: :cascade do |t|
    t.string   "upn",        limit: 255, null: false
    t.string   "name",       limit: 255
    t.string   "surname",    limit: 255
    t.string   "email",      limit: 255
    t.datetime "updated_at"
  end

  add_index "users", ["upn"], name: "index_upn_on_users", using: :btree

  add_foreign_key "cycles", "users", name: "cycles_ibfk_1"
  add_foreign_key "funds", "users", column: "holder_id", name: "funds_ibfk_1"
  add_foreign_key "repayments", "funds", name: "repayments_ibfk_3"
  add_foreign_key "repayments", "seminars", name: "repayments_ibfk_2"
  add_foreign_key "repayments", "users", column: "holder_id", name: "repayments_ibfk_1"
  add_foreign_key "seminars", "users", name: "seminars_ibfk_1"
end
