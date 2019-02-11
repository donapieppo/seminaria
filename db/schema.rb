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

ActiveRecord::Schema.define(version: 2019_02_04_122930) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "approvals", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "highlight_id", null: false, unsigned: true
    t.integer "user_id", null: false, unsigned: true
    t.string "judgment", limit: 3
    t.text "justification"
    t.datetime "updated_at"
    t.index ["highlight_id"], name: "index_approvals_on_hightlight_id"
    t.index ["user_id"], name: "index_approvals_on_user_id"
  end

  create_table "arguments", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 30
  end

  create_table "arguments_seminars", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "argument_id", null: false, unsigned: true
    t.integer "seminar_id", null: false, unsigned: true
    t.index ["argument_id"], name: "argument_id"
    t.index ["seminar_id"], name: "seminar_id"
  end

  create_table "categories", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 200
  end

  create_table "cycles", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.string "title", limit: 250
    t.text "description"
    t.string "committee", limit: 250
    t.string "link", limit: 250
    t.boolean "active"
    t.index ["user_id"], name: "user_id"
  end

  create_table "documents", id: :integer, unsigned: true, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.integer "seminar_id", unsigned: true
    t.integer "repayment_id", unsigned: true
    t.string "description", limit: 200
    t.datetime "created_at"
    t.string "attach_file_name", limit: 200
    t.string "attach_content_type", limit: 100
    t.integer "attach_file_size", unsigned: true
    t.datetime "attach_updated_at"
    t.index ["repayment_id"], name: "repayment_id"
    t.index ["seminar_id"], name: "seminar_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "funds", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 200
    t.string "description"
    t.integer "category_id", null: false, unsigned: true
    t.integer "holder_id", null: false, unsigned: true
    t.date "deadline"
    t.boolean "available"
    t.string "code", limit: 50
  end

  create_table "highlights", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.string "proponent"
    t.string "name", null: false
    t.text "description"
    t.string "link"
    t.string "link_text"
    t.string "priority", limit: 10
    t.integer "position"
    t.boolean "refused"
    t.date "visible_from"
    t.date "visible_to"
    t.datetime "approved_at"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_hightlights_on_user_id"
  end

  create_table "highlights_tags", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "highlight_id", null: false, unsigned: true
    t.integer "tag_id", null: false, unsigned: true
    t.index ["highlight_id"], name: "highlight_id"
    t.index ["tag_id"], name: "tag_id"
  end

  create_table "organizations", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
  end

  create_table "places", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name"
  end

  create_table "positions", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "code", limit: 50
    t.string "name"
  end

  create_table "repayments", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "seminar_id", null: false, unsigned: true
    t.integer "holder_id", unsigned: true
    t.integer "fund_id", unsigned: true
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "address"
    t.string "postalcode"
    t.string "city"
    t.string "country"
    t.boolean "italy"
    t.string "birth_date"
    t.string "birth_place"
    t.string "birth_country"
    t.date "speaker_arrival"
    t.date "speaker_departure"
    t.string "affiliation"
    t.text "reason"
    t.decimal "payment", precision: 8, scale: 2
    t.boolean "gross"
    t.integer "position_id", unsigned: true
    t.string "role"
    t.boolean "refund"
    t.integer "expected_refund"
    t.integer "bond_year", unsigned: true
    t.integer "bond_number", unsigned: true
    t.boolean "notified"
    t.index ["fund_id"], name: "fund_id"
    t.index ["holder_id"], name: "index_repayments_on_holder_id"
    t.index ["seminar_id"], name: "index_repayments_on_seminar_id"
  end

  create_table "seminars", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.integer "organization_id", unsigned: true
    t.datetime "date"
    t.integer "duration"
    t.integer "place_id"
    t.text "place_description"
    t.string "speaker", limit: 250
    t.string "speaker_title", limit: 20
    t.string "committee", limit: 200
    t.string "title", limit: 250
    t.text "abstract"
    t.string "file", limit: 200
    t.string "link", limit: 250
    t.string "link_text"
    t.string "alert_message"
    t.datetime "alert_deadline"
    t.integer "serial_id"
    t.integer "cycle_id"
    t.index ["cycle_id"], name: "index_seminars_on_cycle_id"
    t.index ["serial_id"], name: "index_seminars_on_serial_id"
    t.index ["user_id"], name: "index_seminars_on_user_id"
  end

  create_table "serials", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", limit: 250
    t.text "description"
    t.string "committee", limit: 250
    t.string "link", limit: 250
    t.boolean "active"
  end

  create_table "tags", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
  end

  create_table "users", id: :integer, unsigned: true, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "upn", null: false
    t.string "name"
    t.string "surname"
    t.string "email"
    t.datetime "updated_at"
    t.index ["upn"], name: "index_upn_on_users"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cycles", "users", name: "cycles_ibfk_1"
  add_foreign_key "repayments", "funds", name: "repayments_ibfk_3"
  add_foreign_key "repayments", "seminars", name: "repayments_ibfk_2"
  add_foreign_key "repayments", "users", column: "holder_id", name: "repayments_ibfk_1"
  add_foreign_key "seminars", "users", name: "seminars_ibfk_1"
end
