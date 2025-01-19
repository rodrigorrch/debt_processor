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

ActiveRecord::Schema[8.0].define(version: 2025_01_19_022020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bills", force: :cascade do |t|
    t.bigint "debt_id", null: false
    t.integer "status", default: 0, null: false
    t.string "external_id"
    t.text "error_message"
    t.datetime "generated_at"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debt_id"], name: "index_bills_on_debt_id"
    t.index ["external_id"], name: "index_bills_on_external_id"
    t.index ["status"], name: "index_bills_on_status"
  end

  create_table "debts", force: :cascade do |t|
    t.string "name", null: false
    t.string "government_id", null: false
    t.string "email", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.date "due_date", null: false
    t.string "debt_id", null: false
    t.bigint "file_processing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debt_id"], name: "index_debts_on_debt_id", unique: true
    t.index ["email"], name: "index_debts_on_email"
    t.index ["file_processing_id"], name: "index_debts_on_file_processing_id"
    t.index ["government_id"], name: "index_debts_on_government_id"
  end

  create_table "file_processings", force: :cascade do |t|
    t.string "filename", null: false
    t.integer "status", default: 0, null: false
    t.string "file_blob_id"
    t.text "error_message"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "index_file_processings_on_filename"
    t.index ["status"], name: "index_file_processings_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bills", "debts"
  add_foreign_key "debts", "file_processings"
end
