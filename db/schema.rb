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

ActiveRecord::Schema[7.1].define(version: 2024_11_02_181222) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_items", force: :cascade do |t|
    t.bigint "feedback_id"
    t.string "title"
    t.text "description"
    t.string "status"
    t.string "assigned_to"
    t.datetime "due_date"
    t.string "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feedback_id"], name: "index_action_items_on_feedback_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "feedback_clusters", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.jsonb "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "content"
    t.string "status", default: "new"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "sentiment_score"
    t.string "sentiment"
    t.string "source_page"
    t.string "browser"
    t.string "platform"
    t.string "device_type"
    t.text "suggested_action"
    t.string "keywords", default: [], array: true
    t.integer "cluster_id"
    t.string "assigned_to"
    t.datetime "due_date"
    t.string "priority"
    t.string "referrer"
    t.string "user_session_id"
    t.string "page_title"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_campaign"
  end

  create_table "replies", force: :cascade do |t|
    t.bigint "feedback_id", null: false
    t.text "content", null: false
    t.string "sender_type", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feedback_id"], name: "index_replies_on_feedback_id"
  end

  add_foreign_key "action_items", "feedbacks"
  add_foreign_key "replies", "feedbacks"
end
