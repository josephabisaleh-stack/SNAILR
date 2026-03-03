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

ActiveRecord::Schema[8.1].define(version: 2026_03_03_133205) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "objective_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["objective_id"], name: "index_chats_on_objective_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "role"
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "progress", default: 0
    t.string "status", default: "in_creation"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_objectives_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "done", default: false
    t.bigint "objective_id", null: false
    t.integer "position", default: 1
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "xp_reward"
    t.index ["objective_id"], name: "index_steps_on_objective_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "total_xp", default: 0
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "objectives"
  add_foreign_key "chats", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "objectives", "users"
  add_foreign_key "steps", "objectives"
end
