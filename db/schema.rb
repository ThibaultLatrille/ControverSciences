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

ActiveRecord::Schema.define(version: 20141121094019) do

  create_table "best_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "reference_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "best_comments", ["comment_id"], name: "index_best_comments_on_comment_id"
  add_index "best_comments", ["reference_id"], name: "index_best_comments_on_reference_id"
  add_index "best_comments", ["user_id"], name: "index_best_comments_on_user_id"

  create_table "comment_relationships", force: true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.text     "content"
    t.integer  "votes_plus",   default: 0
    t.integer  "votes_minus",  default: 0
    t.integer  "balance",      default: 0
    t.float    "score",        default: 0.0
    t.boolean  "best",         default: false
    t.text     "f_1_content"
    t.text     "f_2_content"
    t.text     "f_3_content"
    t.text     "f_4_content"
    t.text     "f_5_content"
    t.text     "markdown_1"
    t.text     "markdown_2"
    t.text     "markdown_3"
    t.text     "markdown_4"
    t.text     "markdown_5"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["reference_id"], name: "index_comments_on_reference_id"
  add_index "comments", ["timeline_id"], name: "index_comments_on_timeline_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "following_new_timelines", force: true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "following_new_timelines", ["user_id"], name: "index_following_new_timelines_on_user_id"

  create_table "following_references", force: true do |t|
    t.integer  "user_id"
    t.integer  "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "following_references", ["reference_id"], name: "index_following_references_on_reference_id"
  add_index "following_references", ["user_id"], name: "index_following_references_on_user_id"

  create_table "following_timelines", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "following_timelines", ["timeline_id"], name: "index_following_timelines_on_timeline_id"
  add_index "following_timelines", ["user_id"], name: "index_following_timelines_on_user_id"

  create_table "links", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "reference_id"
    t.integer  "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["comment_id"], name: "index_links_on_comment_id"
  add_index "links", ["reference_id"], name: "index_links_on_reference_id"
  add_index "links", ["timeline_id"], name: "index_links_on_timeline_id"
  add_index "links", ["user_id"], name: "index_links_on_user_id"

  create_table "notification_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.boolean  "read",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_comments", ["comment_id"], name: "index_notification_comments_on_comment_id"
  add_index "notification_comments", ["user_id"], name: "index_notification_comments_on_user_id"

  create_table "notification_references", force: true do |t|
    t.integer  "user_id"
    t.integer  "reference_id"
    t.boolean  "read",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_references", ["reference_id"], name: "index_notification_references_on_reference_id"
  add_index "notification_references", ["user_id"], name: "index_notification_references_on_user_id"

  create_table "notification_selection_losses", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.boolean  "read",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_selection_losses", ["comment_id"], name: "index_notification_selection_losses_on_comment_id"
  add_index "notification_selection_losses", ["user_id"], name: "index_notification_selection_losses_on_user_id"

  create_table "notification_selection_wins", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.boolean  "read",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_selection_wins", ["comment_id"], name: "index_notification_selection_wins_on_comment_id"
  add_index "notification_selection_wins", ["user_id"], name: "index_notification_selection_wins_on_user_id"

  create_table "notification_selections", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.boolean  "read",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_selections", ["comment_id"], name: "index_notification_selections_on_comment_id"
  add_index "notification_selections", ["user_id"], name: "index_notification_selections_on_user_id"

  create_table "notification_timelines", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.boolean  "read",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_timelines", ["timeline_id"], name: "index_notification_timelines_on_timeline_id"
  add_index "notification_timelines", ["user_id"], name: "index_notification_timelines_on_user_id"

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.boolean  "read",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

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
    t.boolean  "star_counted",    default: false
    t.text     "f_1_content"
    t.text     "f_2_content"
    t.text     "f_3_content"
    t.text     "f_4_content"
    t.text     "f_5_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "references", ["timeline_id"], name: "index_references_on_timeline_id"
  add_index "references", ["user_id"], name: "index_references_on_user_id"

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"
  add_index "taggings", ["timeline_id"], name: "index_taggings_on_timeline_id"

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "star_1",                 default: 0
    t.integer  "star_2",                 default: 0
    t.integer  "star_3",                 default: 0
    t.integer  "star_4",                 default: 0
    t.integer  "star_5",                 default: 0
    t.float    "score",                  default: 1.0
    t.float    "score_recent",           default: 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timelines", ["created_at"], name: "index_timelines_on_created_at"
  add_index "timelines", ["user_id"], name: "index_timelines_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.float    "score",                   default: 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                   default: false
    t.string   "activation_digest"
    t.boolean  "activated",               default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "notifications_timeline",  default: 0
    t.integer  "notifications_reference", default: 0
    t.integer  "notifications_comment",   default: 0
    t.integer  "notifications_selection", default: 0
    t.integer  "notifications_win",       default: 0
    t.integer  "notifications_loss",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "comment_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["comment_id"], name: "index_votes_on_comment_id"
  add_index "votes", ["reference_id"], name: "index_votes_on_reference_id"
  add_index "votes", ["timeline_id"], name: "index_votes_on_timeline_id"
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
