# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_17_153830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "wordnote_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "wordnote_id"], name: "index_favorites_on_user_id_and_wordnote_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
    t.index ["wordnote_id"], name: "index_favorites_on_wordnote_id"
  end

  create_table "tango_configs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "wordnote_id", null: false
    t.string "sort", default: "asc"
    t.integer "clicked_num", default: 0
    t.boolean "continue", default: false
    t.string "filter", default: "none"
    t.integer "font_size"
    t.integer "timer", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "last_question"
    t.index ["user_id"], name: "index_tango_configs_on_user_id"
    t.index ["wordnote_id"], name: "index_tango_configs_on_wordnote_id"
  end

  create_table "tango_data", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "wordnote_id", null: false
    t.bigint "tango_id", null: false
    t.integer "trial_num"
    t.integer "wrong_num"
    t.integer "star"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tango_id"], name: "index_tango_data_on_tango_id"
    t.index ["user_id", "wordnote_id", "tango_id"], name: "index_tango_data_on_user_id_and_wordnote_id_and_tango_id", unique: true
    t.index ["user_id"], name: "index_tango_data_on_user_id"
    t.index ["wordnote_id"], name: "index_tango_data_on_wordnote_id"
  end

  create_table "tangos", force: :cascade do |t|
    t.bigint "wordnote_id", null: false
    t.string "question", null: false
    t.string "answer", null: false
    t.string "hint"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_tangos_on_created_at"
    t.index ["wordnote_id", "created_at"], name: "index_tangos_on_wordnote_id_and_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "hashed_password"
    t.string "profile"
    t.boolean "suspended", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.string "profile_image"
    t.index "lower((email)::text)", name: "index_users_on_LOWER_email", unique: true
    t.index ["name"], name: "index_users_on_name"
  end

  create_table "wordnotes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "subject", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_open", default: true
  end

  add_foreign_key "favorites", "users"
  add_foreign_key "favorites", "wordnotes"
  add_foreign_key "tango_configs", "users"
  add_foreign_key "tango_configs", "wordnotes"
end
