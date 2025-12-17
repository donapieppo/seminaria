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

ActiveRecord::Schema[8.1].define(version: 2023_11_22_095652) do
  create_table "active_storage_attachments", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "arguments", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "name", limit: 30
    t.integer "organization_id", unsigned: true
    t.index ["organization_id"], name: "fk_arguments_organization"
  end

  create_table "arguments_seminars", id: false, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "argument_id", null: false, unsigned: true
    t.integer "seminar_id", null: false, unsigned: true
    t.index ["argument_id"], name: "argument_id"
    t.index ["seminar_id"], name: "seminar_id"
  end

  create_table "categories", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "name", limit: 200
  end

  create_table "conferences", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "abstract"
    t.text "committee"
    t.date "end_date"
    t.integer "organization_id", unsigned: true
    t.date "start_date"
    t.string "title", limit: 250
    t.string "url", limit: 250
    t.integer "user_id", unsigned: true
    t.index ["organization_id"], name: "fk_conference_organization"
    t.index ["user_id"], name: "fk_conference_user"
  end

  create_table "cycles", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.boolean "active"
    t.string "committee", limit: 250
    t.text "description"
    t.string "link", limit: 250
    t.integer "organization_id", unsigned: true
    t.string "title", limit: 250
    t.integer "user_id", unsigned: true
    t.index ["organization_id"], name: "fk_cycles_organization"
    t.index ["user_id"], name: "user_id"
  end

  create_table "documents", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description", limit: 200
    t.integer "repayment_id", unsigned: true
    t.integer "seminar_id", unsigned: true
    t.string "type", limit: 100
    t.integer "user_id", unsigned: true
    t.index ["repayment_id"], name: "repayment_id"
    t.index ["seminar_id"], name: "seminar_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "funds", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.boolean "available"
    t.integer "category_id", null: false, unsigned: true
    t.string "code", limit: 50
    t.date "deadline"
    t.string "description"
    t.integer "holder_id", null: false, unsigned: true
    t.string "name", limit: 200
    t.integer "organization_id", unsigned: true
    t.index ["organization_id"], name: "fk_funds_organization"
  end

  create_table "organizations", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "code", limit: 250
    t.string "description"
    t.string "name"
  end

  create_table "permissions", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "authlevel"
    t.string "network", limit: 20
    t.integer "organization_id", null: false, unsigned: true
    t.integer "user_id", null: false, unsigned: true
    t.index ["organization_id"], name: "fk_organization_authorization"
    t.index ["user_id"], name: "fk_user_authorization"
  end

  create_table "places", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.text "name"
    t.integer "organization_id", unsigned: true
    t.index ["organization_id"], name: "fk_places_organization"
  end

  create_table "positions", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "code", limit: 50
    t.string "name"
  end

  create_table "registrations", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "affiliation", limit: 250
    t.datetime "created_at", precision: nil
    t.string "email", limit: 250
    t.string "name", limit: 250
    t.integer "seminar_id", unsigned: true
    t.string "surname", limit: 250
    t.datetime "updated_at", precision: nil
    t.integer "user_id", unsigned: true
    t.index ["seminar_id"], name: "fk_seminars_registrations"
    t.index ["user_id"], name: "fk_users_registrations"
  end

  create_table "repayments", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "aba", limit: 150
    t.text "activity_details"
    t.string "address"
    t.string "affiliation"
    t.string "bank_address"
    t.string "bank_name"
    t.string "birth_country"
    t.string "birth_date"
    t.string "birth_place"
    t.integer "bond_number", unsigned: true
    t.integer "bond_year", unsigned: true
    t.string "city"
    t.string "country"
    t.string "email"
    t.integer "expected_refund"
    t.text "final_notes"
    t.integer "fund_id", unsigned: true
    t.boolean "gross"
    t.integer "holder_id", unsigned: true
    t.string "iban", limit: 150
    t.boolean "italy"
    t.column "language", "enum('it','en')", default: "it"
    t.string "name"
    t.boolean "notified"
    t.decimal "payment", precision: 8, scale: 2
    t.integer "position_id", unsigned: true
    t.string "postalcode"
    t.text "reason"
    t.boolean "refund"
    t.string "role"
    t.text "scientific_interests"
    t.integer "seminar_id", null: false, unsigned: true
    t.date "speaker_arrival"
    t.date "speaker_departure"
    t.string "spkr_token", limit: 250
    t.string "surname"
    t.string "swift", limit: 150
    t.string "taxid", limit: 150
    t.boolean "travel_agency", default: false
    t.integer "ugov"
    t.index ["fund_id"], name: "fund_id"
    t.index ["holder_id"], name: "index_repayments_on_holder_id"
    t.index ["seminar_id"], name: "index_repayments_on_seminar_id"
    t.index ["spkr_token"], name: "spkr_token_on_repayments"
  end

  create_table "seminars", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.text "abstract"
    t.datetime "alert_deadline", precision: nil
    t.string "alert_message"
    t.text "committee"
    t.integer "conference_id", unsigned: true
    t.datetime "created_at", precision: nil
    t.integer "cycle_id"
    t.datetime "date", precision: nil
    t.integer "duration"
    t.string "file", limit: 200
    t.boolean "hidden"
    t.boolean "in_presence"
    t.string "link", limit: 250
    t.string "link_text"
    t.string "meeting_code", limit: 250
    t.string "meeting_url", limit: 250
    t.boolean "meeting_visible"
    t.boolean "on_line"
    t.integer "organization_id", unsigned: true
    t.text "place_description"
    t.integer "place_id"
    t.string "registration_url"
    t.integer "serial_id"
    t.string "speaker", limit: 250
    t.boolean "speaker_on_line", default: false
    t.string "speaker_title", limit: 20
    t.string "title", limit: 250
    t.datetime "updated_at", precision: nil
    t.integer "user_id", unsigned: true
    t.index ["conference_id"], name: "fk_seminars_conference"
    t.index ["cycle_id"], name: "index_seminars_on_cycle_id"
    t.index ["organization_id"], name: "fk_seminars_organization"
    t.index ["serial_id"], name: "index_seminars_on_serial_id"
    t.index ["user_id"], name: "index_seminars_on_user_id"
  end

  create_table "serials", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.boolean "active"
    t.string "committee", limit: 250
    t.text "description"
    t.string "link", limit: 250
    t.integer "organization_id", unsigned: true
    t.string "title", limit: 250
    t.index ["organization_id"], name: "fk_serials_organization"
  end

  create_table "tags", id: { type: :integer, unsigned: true }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.text "description"
    t.string "name", null: false
  end

  create_table "users", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "surname"
    t.datetime "updated_at", precision: nil
    t.string "upn", null: false
    t.index ["upn"], name: "index_upn_on_users"
  end

  create_table "zoom_meetings", id: { type: :bigint, unsigned: true, default: nil }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "join_url"
    t.integer "seminar_id", unsigned: true
    t.text "start_url"
    t.string "uuid", limit: 200
    t.index ["seminar_id"], name: "fk_seminars_zoom_meetings"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "arguments", "organizations", name: "fk_arguments_organization"
  add_foreign_key "conferences", "organizations", name: "fk_conference_organization"
  add_foreign_key "conferences", "users", name: "fk_conference_user"
  add_foreign_key "cycles", "organizations", name: "fk_cycles_organization"
  add_foreign_key "cycles", "users", name: "cycles_ibfk_1"
  add_foreign_key "funds", "organizations", name: "fk_funds_organization"
  add_foreign_key "permissions", "organizations", name: "fk_organization_authorization"
  add_foreign_key "permissions", "users", name: "fk_user_authorization"
  add_foreign_key "places", "organizations", name: "fk_places_organization"
  add_foreign_key "registrations", "seminars", name: "fk_seminars_registrations", on_delete: :cascade
  add_foreign_key "registrations", "users", name: "fk_users_registrations", on_delete: :cascade
  add_foreign_key "repayments", "funds", name: "repayments_ibfk_3"
  add_foreign_key "repayments", "seminars", name: "repayments_ibfk_2"
  add_foreign_key "repayments", "users", column: "holder_id", name: "repayments_ibfk_1"
  add_foreign_key "seminars", "conferences", name: "fk_seminars_conference"
  add_foreign_key "seminars", "organizations", name: "fk_seminars_organization"
  add_foreign_key "seminars", "users", name: "seminars_ibfk_1"
  add_foreign_key "serials", "organizations", name: "fk_serials_organization"
  add_foreign_key "zoom_meetings", "seminars", name: "fk_seminars_zoom_meetings", on_delete: :cascade
end
