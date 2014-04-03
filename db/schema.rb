# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140402051118) do

  create_table "auction_items", force: true do |t|
    t.integer  "auction_id"
    t.string   "image_path"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "min_bid"
    t.integer  "min_incr",           default: 1
    t.integer  "category"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "auction_stats", force: true do |t|
    t.integer  "auction_id"
    t.integer  "funds_raised"
    t.integer  "funds_goal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auctions", force: true do |t|
    t.integer  "user_id"
    t.date     "start_time"
    t.date     "end_time"
    t.string   "name"
    t.text     "description"
    t.string   "banner_image_path"
    t.boolean  "active",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bids", force: true do |t|
    t.integer  "auction_item_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "auction_item_id"
  end

  add_index "comments", ["user_id", "created_at"], name: "index_comments_on_user_id_and_created_at"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
