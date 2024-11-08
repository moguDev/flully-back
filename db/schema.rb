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

ActiveRecord::Schema[7.1].define(version: 2024_11_08_063021) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_images", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.string "image", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_board_images_on_board_id"
  end

  create_table "boards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "category"
    t.integer "species"
    t.string "name"
    t.string "icon"
    t.integer "age"
    t.datetime "date"
    t.float "lat"
    t.float "lng"
    t.boolean "is_location_public"
    t.text "body"
    t.text "feature"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "breed"
    t.string "location"
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "board_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_bookmarks_on_board_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "checkpoints", force: :cascade do |t|
    t.bigint "walk_id", null: false
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["walk_id"], name: "index_checkpoints_on_walk_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "post_comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_comments_on_post_id"
    t.index ["user_id"], name: "index_post_comments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "walk_id", null: false
    t.string "image"
    t.text "body"
    t.float "lat"
    t.float "lng"
    t.boolean "is_anonymous"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
    t.index ["walk_id"], name: "index_posts_on_walk_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "introduction"
    t.string "location"
    t.string "avatar"
    t.string "twitter"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "walks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_time"
    t.datetime "finish_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_walks_on_user_id"
  end

  add_foreign_key "board_images", "boards"
  add_foreign_key "boards", "users"
  add_foreign_key "bookmarks", "boards"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "checkpoints", "walks"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "post_comments", "posts"
  add_foreign_key "post_comments", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "posts", "walks"
  add_foreign_key "walks", "users"
end
