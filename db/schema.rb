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

ActiveRecord::Schema.define(version: 20180207214645) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photos", force: :cascade do |t|
    t.bigint "reading_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "category"
    t.index ["reading_id"], name: "index_photos_on_reading_id"
  end

  create_table "readings", force: :cascade do |t|
    t.float "depth"
    t.string "units_depth"
    t.integer "salinity"
    t.string "units_salinity"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved"
    t.float "latitude"
    t.float "longitude"
    t.datetime "deleted_at"
    t.index ["approved"], name: "index_readings_on_approved"
    t.index ["deleted_at"], name: "index_readings_on_deleted_at"
  end

  create_table "secret_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "key"
  end

  add_foreign_key "photos", "readings"
end
