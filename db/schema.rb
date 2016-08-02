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

  create_table "admins", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",         unsigned: true
    t.integer "organization_id", unsigned: true
    t.integer "authlevel",       unsigned: true
    t.index ["organization_id"], name: "organization_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "cycles", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",                   unsigned: true
    t.string  "title",       limit: 250
    t.text    "description", limit: 65535
    t.string  "committee",   limit: 250
    t.string  "link",        limit: 250
    t.boolean "active"
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "disciplines", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 30
  end

  create_table "documents", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                         unsigned: true
    t.integer  "seminar_id",                      unsigned: true
    t.integer  "repayment_id",                    unsigned: true
    t.string   "description",         limit: 200
    t.datetime "created_at"
    t.string   "attach_file_name",    limit: 200
    t.string   "attach_content_type", limit: 100
    t.integer  "attach_file_size",                unsigned: true
    t.datetime "attach_updated_at"
    t.index ["repayment_id"], name: "repayment_id", using: :btree
    t.index ["seminar_id"], name: "seminar_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "funds", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",        limit: 200
    t.string  "description"
    t.integer "category_id",             null: false, unsigned: true
    t.integer "holder_id",               null: false, unsigned: true
    t.date    "deadline"
    t.boolean "available"
    t.string  "code",        limit: 50
    t.index ["holder_id"], name: "holder_id", using: :btree
  end

  create_table "organizations", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name",                      null: false
    t.text   "description", limit: 65535
  end

  create_table "places", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text   "name",    limit: 65535
    t.text   "address", limit: 65535
    t.string "city"
  end

  create_table "repayments", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "seminar_id",                                null: false, unsigned: true
    t.integer "holder_id",                                 null: false, unsigned: true
    t.integer "fund_id",                                                unsigned: true
    t.string  "name"
    t.string  "surname"
    t.string  "email"
    t.string  "address"
    t.string  "postalcode"
    t.string  "city"
    t.string  "country"
    t.boolean "italy"
    t.string  "birth_date"
    t.string  "birth_place"
    t.string  "birth_country"
    t.date    "speaker_arrival"
    t.date    "speaker_departure"
    t.string  "affiliation"
    t.decimal "payment",           precision: 8, scale: 2
    t.boolean "gross"
    t.string  "role"
    t.boolean "refund"
    t.integer "expected_refund"
    t.boolean "notified"
    t.index ["fund_id"], name: "fund_id", using: :btree
    t.index ["holder_id"], name: "holder_id", using: :btree
    t.index ["seminar_id"], name: "seminar_id", using: :btree
  end

  create_table "rooms", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text    "name",        limit: 65535
    t.text    "description", limit: 65535
    t.integer "place_id",                  unsigned: true
    t.index ["place_id"], name: "place_id", using: :btree
  end

  create_table "seminars", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                        unsigned: true
    t.integer  "organization_id",                unsigned: true
    t.datetime "date"
    t.integer  "duration"
    t.integer  "room_id",                        unsigned: true
    t.text     "room_description", limit: 65535
    t.string   "speaker",          limit: 250
    t.string   "speaker_title",    limit: 20
    t.string   "committee",        limit: 200
    t.string   "title",            limit: 250
    t.text     "abstract",         limit: 65535
    t.string   "file",             limit: 200
    t.string   "link",             limit: 250
    t.string   "link_text"
    t.string   "alert_message"
    t.datetime "alert_deadline"
    t.integer  "serial_id",                      unsigned: true
    t.integer  "cycle_id",                       unsigned: true
    t.index ["cycle_id"], name: "cycle_id", using: :btree
    t.index ["organization_id"], name: "organization_id", using: :btree
    t.index ["room_id"], name: "room_id", using: :btree
    t.index ["serial_id"], name: "serial_id", using: :btree
    t.index ["user_id"], name: "user_id", using: :btree
  end

  create_table "serials", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "title",       limit: 250
    t.text    "description", limit: 65535
    t.string  "committee",   limit: 250
    t.string  "link",        limit: 250
    t.boolean "active"
  end

  create_table "tags", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name",                      null: false
    t.text   "description", limit: 65535
  end

  create_table "topics", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "discipline_id",            unsigned: true
    t.string  "name",          limit: 30
    t.index ["discipline_id"], name: "discipline_id", using: :btree
  end

  create_table "topics_seminars", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "topic_id",   null: false, unsigned: true
    t.integer "seminar_id", null: false, unsigned: true
    t.index ["seminar_id"], name: "seminar_id", using: :btree
    t.index ["topic_id"], name: "topic_id", using: :btree
  end

  create_table "users", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "upn",        null: false
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.datetime "updated_at"
    t.index ["upn"], name: "index_upn_on_users", using: :btree
  end

  add_foreign_key "admins", "organizations", name: "admins_ibfk_2"
  add_foreign_key "admins", "users", name: "admins_ibfk_1"
  add_foreign_key "cycles", "users", name: "cycles_ibfk_1"
  add_foreign_key "funds", "users", column: "holder_id", name: "funds_ibfk_1"
  add_foreign_key "repayments", "funds", name: "repayments_ibfk_3"
  add_foreign_key "repayments", "seminars", name: "repayments_ibfk_2"
  add_foreign_key "repayments", "users", column: "holder_id", name: "repayments_ibfk_1"
  add_foreign_key "rooms", "places", name: "rooms_ibfk_1"
  add_foreign_key "seminars", "cycles", name: "seminars_ibfk_4"
  add_foreign_key "seminars", "organizations", name: "seminars_ibfk_5"
  add_foreign_key "seminars", "rooms", name: "seminars_ibfk_2"
  add_foreign_key "seminars", "serials", name: "seminars_ibfk_3"
  add_foreign_key "seminars", "users", name: "seminars_ibfk_1"
  add_foreign_key "topics", "disciplines", name: "topics_ibfk_1"
end
