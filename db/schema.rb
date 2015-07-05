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

ActiveRecord::Schema.define(version: 20150705090122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "best_comments", force: true do |t|
    t.integer  "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "f_0_comment_id"
    t.integer  "f_1_comment_id"
    t.integer  "f_2_comment_id"
    t.integer  "f_3_comment_id"
    t.integer  "f_4_comment_id"
    t.integer  "f_5_comment_id"
    t.integer  "f_6_comment_id"
    t.integer  "f_7_comment_id"
    t.integer  "f_0_user_id"
    t.integer  "f_1_user_id"
    t.integer  "f_2_user_id"
    t.integer  "f_3_user_id"
    t.integer  "f_4_user_id"
    t.integer  "f_5_user_id"
    t.integer  "f_6_user_id"
    t.integer  "f_7_user_id"
  end

  add_index "best_comments", ["reference_id"], name: "index_best_comments_on_reference_id", using: :btree

  create_table "binaries", force: true do |t|
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "binaries", ["reference_id"], name: "index_binaries_on_reference_id", using: :btree
  add_index "binaries", ["timeline_id"], name: "index_binaries_on_timeline_id", using: :btree
  add_index "binaries", ["user_id"], name: "index_binaries_on_user_id", using: :btree

  create_table "comment_joins", force: true do |t|
    t.integer  "reference_id"
    t.integer  "comment_id"
    t.integer  "field"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comment_joins", ["comment_id"], name: "index_comment_joins_on_comment_id", using: :btree
  add_index "comment_joins", ["reference_id"], name: "index_comment_joins_on_reference_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.text     "f_0_content",      default: ""
    t.text     "f_1_content",      default: ""
    t.text     "f_2_content",      default: ""
    t.text     "f_3_content",      default: ""
    t.text     "f_4_content",      default: ""
    t.text     "f_5_content",      default: ""
    t.text     "markdown_0",       default: ""
    t.text     "markdown_1",       default: ""
    t.text     "markdown_2",       default: ""
    t.text     "markdown_3",       default: ""
    t.text     "markdown_4",       default: ""
    t.text     "markdown_5",       default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",           default: true
    t.text     "caption",          default: ""
    t.text     "caption_markdown", default: ""
    t.text     "title",            default: ""
    t.text     "title_markdown",   default: ""
    t.integer  "f_0_balance",      default: 0
    t.integer  "f_1_balance",      default: 0
    t.integer  "f_2_balance",      default: 0
    t.integer  "f_3_balance",      default: 0
    t.integer  "f_4_balance",      default: 0
    t.integer  "f_5_balance",      default: 0
    t.integer  "f_6_balance",      default: 0
    t.integer  "f_7_balance",      default: 0
    t.float    "f_0_score",        default: 0.0
    t.float    "f_1_score",        default: 0.0
    t.float    "f_2_score",        default: 0.0
    t.float    "f_3_score",        default: 0.0
    t.float    "f_4_score",        default: 0.0
    t.float    "f_5_score",        default: 0.0
    t.float    "f_6_score",        default: 0.0
    t.float    "f_7_score",        default: 0.0
    t.integer  "figure_id"
    t.boolean  "notif_generated",  default: false
  end

  add_index "comments", ["figure_id"], name: "index_comments_on_figure_id", using: :btree
  add_index "comments", ["reference_id"], name: "index_comments_on_reference_id", using: :btree
  add_index "comments", ["timeline_id"], name: "index_comments_on_timeline_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "credits", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "summary_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credits", ["summary_id"], name: "index_credits_on_summary_id", using: :btree
  add_index "credits", ["timeline_id"], name: "index_credits_on_timeline_id", using: :btree
  add_index "credits", ["user_id"], name: "index_credits_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "domains", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edge_votes", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "edge_id"
    t.boolean  "value"
  end

  add_index "edge_votes", ["edge_id"], name: "index_edge_votes_on_edge_id", using: :btree
  add_index "edge_votes", ["user_id"], name: "index_edge_votes_on_user_id", using: :btree

  create_table "edges", force: true do |t|
    t.integer  "timeline_id"
    t.integer  "target"
    t.integer  "weight",      default: 1
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reversible",  default: false
  end

  add_index "edges", ["timeline_id"], name: "index_edges_on_timeline_id", using: :btree

  create_table "figures", force: true do |t|
    t.integer  "reference_id"
    t.integer  "timeline_id"
    t.integer  "user_id"
    t.boolean  "profil"
    t.string   "picture"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "figures", ["reference_id"], name: "index_figures_on_reference_id", using: :btree
  add_index "figures", ["timeline_id"], name: "index_figures_on_timeline_id", using: :btree
  add_index "figures", ["user_id"], name: "index_figures_on_user_id", using: :btree

  create_table "frame_credits", force: true do |t|
    t.integer  "timeline_id"
    t.integer  "user_id"
    t.integer  "frame_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "frame_credits", ["frame_id"], name: "index_frame_credits_on_frame_id", using: :btree
  add_index "frame_credits", ["timeline_id"], name: "index_frame_credits_on_timeline_id", using: :btree
  add_index "frame_credits", ["user_id"], name: "index_frame_credits_on_user_id", using: :btree

  create_table "frame_taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "frame_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "frame_taggings", ["frame_id"], name: "index_frame_taggings_on_frame_id", using: :btree
  add_index "frame_taggings", ["tag_id"], name: "index_frame_taggings_on_tag_id", using: :btree

  create_table "frames", force: true do |t|
    t.integer  "timeline_id"
    t.integer  "user_id"
    t.text     "name"
    t.text     "content"
    t.text     "name_markdown"
    t.text     "content_markdown"
    t.float    "score",            default: 0.0
    t.integer  "balance",          default: 0
    t.boolean  "best",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "binary",           default: ""
  end

  add_index "frames", ["timeline_id"], name: "index_frames_on_timeline_id", using: :btree
  add_index "frames", ["user_id"], name: "index_frames_on_user_id", using: :btree

  create_table "invitations", force: true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.text     "target_email"
    t.text     "target_name"
    t.text     "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["reference_id"], name: "index_invitations_on_reference_id", using: :btree
  add_index "invitations", ["timeline_id"], name: "index_invitations_on_timeline_id", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

  create_table "issues", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "labels",     default: [], array: true
    t.string   "author"
    t.integer  "importance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "likes", force: true do |t|
    t.integer  "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "links", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "reference_id"
    t.integer  "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["comment_id"], name: "index_links_on_comment_id", using: :btree
  add_index "links", ["reference_id"], name: "index_links_on_reference_id", using: :btree
  add_index "links", ["timeline_id"], name: "index_links_on_timeline_id", using: :btree
  add_index "links", ["user_id"], name: "index_links_on_user_id", using: :btree

  create_table "newsletters", force: true do |t|
    t.text     "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_frame_selection_losses", force: true do |t|
    t.integer  "frame_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_frame_selection_losses", ["frame_id"], name: "index_notification_frame_selection_losses_on_frame_id", using: :btree
  add_index "notification_frame_selection_losses", ["user_id"], name: "index_notification_frame_selection_losses_on_user_id", using: :btree

  create_table "notification_frame_selection_wins", force: true do |t|
    t.integer  "frame_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_frame_selection_wins", ["frame_id"], name: "index_notification_frame_selection_wins_on_frame_id", using: :btree
  add_index "notification_frame_selection_wins", ["user_id"], name: "index_notification_frame_selection_wins_on_user_id", using: :btree

  create_table "notification_selection_losses", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "field"
  end

  add_index "notification_selection_losses", ["comment_id"], name: "index_notification_selection_losses_on_comment_id", using: :btree
  add_index "notification_selection_losses", ["user_id"], name: "index_notification_selection_losses_on_user_id", using: :btree

  create_table "notification_selection_wins", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "field"
  end

  add_index "notification_selection_wins", ["comment_id"], name: "index_notification_selection_wins_on_comment_id", using: :btree
  add_index "notification_selection_wins", ["user_id"], name: "index_notification_selection_wins_on_user_id", using: :btree

  create_table "notification_suggestions", force: true do |t|
    t.integer  "user_id"
    t.integer  "suggestion_child_id"
    t.integer  "suggestion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_suggestions", ["suggestion_child_id"], name: "index_notification_suggestions_on_suggestion_child_id", using: :btree
  add_index "notification_suggestions", ["suggestion_id"], name: "index_notification_suggestions_on_suggestion_id", using: :btree
  add_index "notification_suggestions", ["user_id"], name: "index_notification_suggestions_on_user_id", using: :btree

  create_table "notification_summary_selection_losses", force: true do |t|
    t.integer  "user_id"
    t.integer  "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_summary_selection_losses", ["summary_id"], name: "index_notification_summary_selection_losses_on_summary_id", using: :btree
  add_index "notification_summary_selection_losses", ["user_id"], name: "index_notification_summary_selection_losses_on_user_id", using: :btree

  create_table "notification_summary_selection_wins", force: true do |t|
    t.integer  "summary_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_summary_selection_wins", ["summary_id"], name: "index_notification_summary_selection_wins_on_summary_id", using: :btree
  add_index "notification_summary_selection_wins", ["user_id"], name: "index_notification_summary_selection_wins_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "summary_id"
    t.integer  "comment_id"
    t.integer  "like_id"
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "field"
    t.integer  "suggestion_id"
    t.integer  "frame_id"
  end

  add_index "notifications", ["comment_id"], name: "index_notifications_on_comment_id", using: :btree
  add_index "notifications", ["frame_id"], name: "index_notifications_on_frame_id", using: :btree
  add_index "notifications", ["like_id"], name: "index_notifications_on_like_id", using: :btree
  add_index "notifications", ["reference_id"], name: "index_notifications_on_reference_id", using: :btree
  add_index "notifications", ["suggestion_id"], name: "index_notifications_on_suggestion_id", using: :btree
  add_index "notifications", ["summary_id"], name: "index_notifications_on_summary_id", using: :btree
  add_index "notifications", ["timeline_id"], name: "index_notifications_on_timeline_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "pending_users", force: true do |t|
    t.integer  "user_id"
    t.text     "why"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pending_users", ["user_id"], name: "index_pending_users_on_user_id", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "reference_id"
    t.integer  "timeline_id"
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["reference_id"], name: "index_ratings_on_reference_id", using: :btree
  add_index "ratings", ["timeline_id"], name: "index_ratings_on_timeline_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "reference_contributors", force: true do |t|
    t.integer  "user_id"
    t.integer  "reference_id"
    t.boolean  "bool"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_contributors", ["reference_id"], name: "index_reference_contributors_on_reference_id", using: :btree
  add_index "reference_contributors", ["user_id"], name: "index_reference_contributors_on_user_id", using: :btree

  create_table "reference_edge_votes", force: true do |t|
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "target"
    t.integer  "user_id"
    t.boolean  "reversible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_edge_votes", ["reference_id"], name: "index_reference_edge_votes_on_reference_id", using: :btree
  add_index "reference_edge_votes", ["timeline_id"], name: "index_reference_edge_votes_on_timeline_id", using: :btree
  add_index "reference_edge_votes", ["user_id"], name: "index_reference_edge_votes_on_user_id", using: :btree

  create_table "reference_edges", force: true do |t|
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "target"
    t.integer  "weight",       default: 1
    t.integer  "user_id"
    t.boolean  "reversible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_edges", ["reference_id"], name: "index_reference_edges_on_reference_id", using: :btree
  add_index "reference_edges", ["timeline_id"], name: "index_reference_edges_on_timeline_id", using: :btree
  add_index "reference_edges", ["user_id"], name: "index_reference_edges_on_user_id", using: :btree

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
    t.boolean  "open_access",       default: true
    t.text     "abstract",          default: ""
    t.integer  "nb_contributors",   default: 0
    t.integer  "nb_edits",          default: 0
    t.integer  "nb_votes",          default: 0
    t.integer  "star_1",            default: 0
    t.integer  "star_2",            default: 0
    t.integer  "star_3",            default: 0
    t.integer  "star_4",            default: 0
    t.integer  "star_5",            default: 0
    t.integer  "star_most",         default: 0
    t.integer  "binary_1",          default: 0
    t.integer  "binary_2",          default: 0
    t.integer  "binary_3",          default: 0
    t.integer  "binary_4",          default: 0
    t.integer  "binary_5",          default: 0
    t.integer  "binary_most",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "binary",            default: ""
    t.boolean  "article",           default: true
    t.text     "abstract_markdown", default: ""
  end

  add_index "references", ["timeline_id"], name: "index_references_on_timeline_id", using: :btree
  add_index "references", ["user_id"], name: "index_references_on_user_id", using: :btree

  create_table "suggestion_child_votes", force: true do |t|
    t.integer  "suggestion_child_id"
    t.boolean  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "suggestion_child_votes", ["user_id"], name: "index_suggestion_child_votes_on_user_id", using: :btree

  create_table "suggestion_children", force: true do |t|
    t.integer  "user_id"
    t.integer  "suggestion_id"
    t.text     "comment"
    t.integer  "balance",          default: 0
    t.integer  "plus",             default: 0
    t.integer  "minus",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content_markdown", default: ""
  end

  add_index "suggestion_children", ["suggestion_id"], name: "index_suggestion_children_on_suggestion_id", using: :btree
  add_index "suggestion_children", ["user_id"], name: "index_suggestion_children_on_user_id", using: :btree

  create_table "suggestion_votes", force: true do |t|
    t.integer  "suggestion_id"
    t.boolean  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "suggestion_votes", ["user_id"], name: "index_suggestion_votes_on_user_id", using: :btree

  create_table "suggestions", force: true do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.integer  "timeline_id"
    t.integer  "balance",          default: 0
    t.integer  "plus",             default: 0
    t.integer  "minus",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "children",         default: 0
    t.text     "content_markdown", default: ""
  end

  add_index "suggestions", ["user_id"], name: "index_suggestions_on_user_id", using: :btree

  create_table "summaries", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "balance",          default: 0
    t.float    "score"
    t.boolean  "best",             default: false
    t.text     "content",          default: ""
    t.text     "markdown",         default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",           default: true
    t.text     "caption",          default: ""
    t.text     "caption_markdown", default: ""
    t.integer  "figure_id"
    t.boolean  "notif_generated",  default: false
  end

  add_index "summaries", ["figure_id"], name: "index_summaries_on_figure_id", using: :btree
  add_index "summaries", ["timeline_id"], name: "index_summaries_on_timeline_id", using: :btree
  add_index "summaries", ["user_id"], name: "index_summaries_on_user_id", using: :btree

  create_table "summary_bests", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "summary_bests", ["summary_id"], name: "index_summary_bests_on_summary_id", using: :btree
  add_index "summary_bests", ["timeline_id"], name: "index_summary_bests_on_timeline_id", using: :btree
  add_index "summary_bests", ["user_id"], name: "index_summary_bests_on_user_id", using: :btree

  create_table "summary_links", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "summary_links", ["reference_id"], name: "index_summary_links_on_reference_id", using: :btree
  add_index "summary_links", ["summary_id"], name: "index_summary_links_on_summary_id", using: :btree
  add_index "summary_links", ["timeline_id"], name: "index_summary_links_on_timeline_id", using: :btree
  add_index "summary_links", ["user_id"], name: "index_summary_links_on_user_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["timeline_id"], name: "index_taggings_on_timeline_id", using: :btree

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

  add_index "timeline_contributors", ["timeline_id"], name: "index_timeline_contributors_on_timeline_id", using: :btree
  add_index "timeline_contributors", ["user_id"], name: "index_timeline_contributors_on_user_id", using: :btree

  create_table "timelines", force: true do |t|
    t.text     "name"
    t.integer  "user_id"
    t.integer  "nb_references",   default: 0
    t.integer  "nb_contributors", default: 0
    t.integer  "nb_likes",        default: 0
    t.integer  "nb_comments",     default: 0
    t.integer  "nb_summaries",    default: 0
    t.float    "score",           default: 1.0
    t.float    "score_recent",    default: 1.0
    t.boolean  "debate",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "binary",          default: ""
    t.integer  "binary_0",        default: 0
    t.integer  "binary_1",        default: 0
    t.integer  "binary_2",        default: 0
    t.integer  "binary_3",        default: 0
    t.integer  "binary_4",        default: 0
    t.integer  "binary_5",        default: 0
    t.integer  "nb_frames",       default: 0
    t.text     "frame",           default: ""
  end

  add_index "timelines", ["created_at"], name: "index_timelines_on_created_at", using: :btree
  add_index "timelines", ["user_id"], name: "index_timelines_on_user_id", using: :btree

  create_table "typos", force: true do |t|
    t.integer  "user_id"
    t.integer  "summary_id"
    t.integer  "comment_id"
    t.integer  "field"
    t.integer  "target_user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "frame_id"
  end

  add_index "typos", ["comment_id"], name: "index_typos_on_comment_id", using: :btree
  add_index "typos", ["frame_id"], name: "index_typos_on_frame_id", using: :btree
  add_index "typos", ["summary_id"], name: "index_typos_on_summary_id", using: :btree
  add_index "typos", ["user_id"], name: "index_typos_on_user_id", using: :btree

  create_table "user_details", force: true do |t|
    t.integer  "user_id"
    t.string   "institution"
    t.string   "job"
    t.string   "website"
    t.text     "biography"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "figure_id"
    t.text     "content_markdown", default: ""
    t.boolean  "send_email",       default: true
  end

  add_index "user_details", ["figure_id"], name: "index_user_details_on_figure_id", using: :btree
  add_index "user_details", ["user_id"], name: "index_user_details_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.float    "score",             default: 1.0
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
    t.integer  "important"
    t.integer  "nb_notifs",         default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "visite_references", force: true do |t|
    t.integer  "user_id"
    t.integer  "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visite_references", ["reference_id"], name: "index_visite_references_on_reference_id", using: :btree
  add_index "visite_references", ["user_id", "reference_id"], name: "index_visite_references_on_user_id_and_reference_id", unique: true, using: :btree
  add_index "visite_references", ["user_id"], name: "index_visite_references_on_user_id", using: :btree

  create_table "visite_timelines", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visite_timelines", ["timeline_id"], name: "index_visite_timelines_on_timeline_id", using: :btree
  add_index "visite_timelines", ["user_id", "timeline_id"], name: "index_visite_timelines_on_user_id_and_timeline_id", unique: true, using: :btree
  add_index "visite_timelines", ["user_id"], name: "index_visite_timelines_on_user_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "timeline_id"
    t.integer  "reference_id"
    t.integer  "comment_id"
    t.integer  "value",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "field"
  end

  add_index "votes", ["comment_id"], name: "index_votes_on_comment_id", using: :btree
  add_index "votes", ["reference_id"], name: "index_votes_on_reference_id", using: :btree
  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree

end
