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

ActiveRecord::Schema.define(version: 20161225142151) do

  create_table "event_users", force: :cascade do |t|
    t.integer  "event_id",   null: false
    t.integer  "user_id",    null: false
    t.boolean  "owner",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_users_on_event_id"
    t.index ["user_id"], name: "index_event_users_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "event_id"
    t.string   "title"
    t.string   "catch"
    t.string   "description"
    t.string   "event_url"
    t.string   "started_at"
    t.string   "ended_at"
    t.string   "url"
    t.string   "address"
    t.string   "place"
    t.string   "lat"
    t.string   "lon"
    t.string   "limit"
    t.string   "accepted"
    t.string   "waiting"
    t.datetime "updated_at",  null: false
    t.string   "hash_tag"
    t.string   "place_enc"
    t.string   "source"
    t.string   "group_url"
    t.string   "group_id"
    t.string   "group_title"
    t.string   "group_logo"
    t.string   "logo"
    t.datetime "created_at",  null: false
    t.string   "update_time"
  end

  create_table "users", force: :cascade do |t|
    t.string   "connpass_id"
    t.string   "atnd_id"
    t.string   "twitter_id"
    t.string   "facebook_id"
    t.string   "github_id"
    t.string   "linkedin_id"
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
