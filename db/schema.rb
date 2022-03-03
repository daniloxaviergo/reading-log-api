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

ActiveRecord::Schema.define(version: 2022_03_02_131712) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "logs", force: :cascade do |t|
    t.bigint "project_id"
    t.datetime "data"
    t.integer "start_page"
    t.integer "end_page"
    t.integer "wday"
    t.text "note"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_logs_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.integer "total_page", default: 0
    t.date "started_at"
    t.integer "page", default: 0
    t.boolean "reinicia", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "watsons", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "minutes"
    t.string "external_id"
    t.bigint "log_id"
    t.bigint "project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["log_id"], name: "index_watsons_on_log_id"
    t.index ["project_id"], name: "index_watsons_on_project_id"
  end

end
