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

ActiveRecord::Schema.define(version: 20141103124421) do

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "field"
    t.text     "content"
    t.integer  "votes_plus",   default: 0
    t.integer  "votes_minus",  default: 0
    t.integer  "rank",         default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["reference_id"], name: "index_comments_on_reference_id"
  add_index "comments", ["timeline_id"], name: "index_comments_on_timeline_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "ratings", force: true do |t|
    t.integer  "reference_id"
    t.integer  "timeline_id"
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["reference_id"], name: "index_ratings_on_reference_id"
  add_index "ratings", ["timeline_id"], name: "index_ratings_on_timeline_id"
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id"

  create_table "reference_contributors", force: true do |t|
    t.integer  "user_id"
    t.integer  "reference_id"
    t.boolean  "bool"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_contributors", ["reference_id"], name: "index_reference_contributors_on_reference_id"
  add_index "reference_contributors", ["user_id"], name: "index_reference_contributors_on_user_id"

  create_table "references", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.text     "doi"
    t.text     "url"
    t.integer  "year"
    t.text     "title"
    t.text     "title_fr"
    t.text     "author"
    t.text     "journal"
    t.text     "publisher"
    t.text     "abstract",        default: ""
    t.integer  "nb_contributors", default: 0
    t.integer  "nb_edits",        default: 0
    t.integer  "nb_votes",        default: 0
    t.integer  "nb_votes_star",   default: 0
    t.integer  "star_1",          default: 0
    t.integer  "star_2",          default: 0
    t.integer  "star_3",          default: 0
    t.integer  "star_4",          default: 0
    t.integer  "star_5",          default: 0
    t.integer  "star_most",       default: 0
    t.integer  "f_1_id"
    t.text     "f_1_content"
    t.integer  "f_1_votes_plus"
    t.integer  "f_1_votes_minus"
    t.integer  "f_2_id"
    t.text     "f_2_content"
    t.integer  "f_2_votes_plus"
    t.integer  "f_2_votes_minus"
    t.integer  "f_3_id"
    t.text     "f_3_content"
    t.integer  "f_3_votes_plus"
    t.integer  "f_3_votes_minus"
    t.integer  "f_4_id"
    t.text     "f_4_content"
    t.integer  "f_4_votes_plus"
    t.integer  "f_4_votes_minus"
    t.integer  "f_5_id"
    t.text     "f_5_content"
    t.integer  "f_5_votes_plus"
    t.integer  "f_5_votes_minus"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "references", ["timeline_id"], name: "index_references_on_timeline_id"
  add_index "references", ["user_id"], name: "index_references_on_user_id"

  create_table "timeline_contributors", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.boolean  "bool"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timeline_contributors", ["timeline_id"], name: "index_timeline_contributors_on_timeline_id"
  add_index "timeline_contributors", ["user_id"], name: "index_timeline_contributors_on_user_id"

  create_table "timelines", force: true do |t|
    t.text     "name"
    t.integer  "user_id"
    t.integer  "timeline_edit_id"
    t.text     "timeline_edit_content"
    t.integer  "timeline_edit_votes",    default: 0
    t.text     "timeline_edit_username"
    t.integer  "nb_references",          default: 0
    t.integer  "nb_contributors",        default: 0
    t.integer  "nb_votes",               default: 0
    t.integer  "nb_votes_star",          default: 0
    t.integer  "nb_edits",               default: 0
    t.float    "rank",                   default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timelines", ["created_at"], name: "index_timelines_on_created_at"
  add_index "timelines", ["user_id"], name: "index_timelines_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "comment_id"
    t.integer  "field"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["comment_id"], name: "index_votes_on_comment_id"
  add_index "votes", ["reference_id"], name: "index_votes_on_reference_id"
  add_index "votes", ["timeline_id"], name: "index_votes_on_timeline_id"
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
