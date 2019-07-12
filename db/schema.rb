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

ActiveRecord::Schema.define(version: 20190712161132) do

  create_table "event_tags", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_tags_on_event_id"
    t.index ["tag_id"], name: "index_event_tags_on_tag_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.string   "catch"
    t.string   "description"
    t.string   "event_url"
    t.string   "url"
    t.string   "address"
    t.string   "place"
    t.datetime "updated_at",                                                  null: false
    t.string   "hash_tag"
    t.string   "place_enc"
    t.string   "source"
    t.string   "group_url"
    t.string   "group_title"
    t.string   "group_logo_url"
    t.string   "logo_url"
    t.datetime "created_at",                                                  null: false
    t.boolean  "tweeted_new",                                 default: false, null: false
    t.boolean  "tweeted_tomorrow",                            default: false, null: false
    t.string   "twitter_list_name"
    t.string   "twitter_list_url"
    t.integer  "event_id"
    t.integer  "limit"
    t.integer  "accepted"
    t.integer  "waiting"
    t.integer  "group_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "update_time"
    t.decimal  "lat",               precision: 17, scale: 14
    t.decimal  "lon",               precision: 17, scale: 14
    t.index ["event_url"], name: "index_events_on_event_url"
    t.index ["started_at"], name: "index_events_on_started_at"
    t.index [nil], name: "index_events_on_twitter_id"
  end

  create_table "participants", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.boolean  "owner",      default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["event_id"], name: "index_participants_on_event_id"
    t.index ["owner"], name: "index_participants_on_owner"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "tag_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "connpass_id"
    t.string   "twitter_id"
    t.string   "facebook_id"
    t.string   "github_id"
    t.string   "linkedin_id"
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "atnd_id"
  end

end
