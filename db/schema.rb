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

ActiveRecord::Schema.define(version: 2019_01_09_124408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "best_comments", id: :serial, force: :cascade do |t|
    t.integer "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "f_0_comment_id"
    t.integer "f_1_comment_id"
    t.integer "f_2_comment_id"
    t.integer "f_3_comment_id"
    t.integer "f_4_comment_id"
    t.integer "f_5_comment_id"
    t.integer "f_6_comment_id"
    t.integer "f_7_comment_id"
    t.integer "f_0_user_id"
    t.integer "f_1_user_id"
    t.integer "f_2_user_id"
    t.integer "f_3_user_id"
    t.integer "f_4_user_id"
    t.integer "f_5_user_id"
    t.integer "f_6_user_id"
    t.integer "f_7_user_id"
    t.index ["reference_id"], name: "index_best_comments_on_reference_id"
  end

  create_table "binaries", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "reference_id"
    t.integer "user_id"
    t.integer "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "frame_id"
    t.index ["reference_id"], name: "index_binaries_on_reference_id"
    t.index ["timeline_id"], name: "index_binaries_on_timeline_id"
    t.index ["user_id"], name: "index_binaries_on_user_id"
  end

  create_table "comment_joins", id: :serial, force: :cascade do |t|
    t.integer "reference_id"
    t.integer "comment_id"
    t.integer "field"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["comment_id"], name: "index_comment_joins_on_comment_id"
    t.index ["reference_id"], name: "index_comment_joins_on_reference_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.integer "reference_id"
    t.text "f_0_content", default: ""
    t.text "f_1_content", default: ""
    t.text "f_2_content", default: ""
    t.text "f_3_content", default: ""
    t.text "f_4_content", default: ""
    t.text "f_5_content", default: ""
    t.text "markdown_0", default: ""
    t.text "markdown_1", default: ""
    t.text "markdown_2", default: ""
    t.text "markdown_3", default: ""
    t.text "markdown_4", default: ""
    t.text "markdown_5", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "public", default: true
    t.text "caption", default: ""
    t.text "caption_markdown", default: ""
    t.text "title", default: ""
    t.text "title_markdown", default: ""
    t.integer "f_0_balance", default: 0
    t.integer "f_1_balance", default: 0
    t.integer "f_2_balance", default: 0
    t.integer "f_3_balance", default: 0
    t.integer "f_4_balance", default: 0
    t.integer "f_5_balance", default: 0
    t.integer "f_6_balance", default: 0
    t.integer "f_7_balance", default: 0
    t.float "f_0_score", default: 0.0
    t.float "f_1_score", default: 0.0
    t.float "f_2_score", default: 0.0
    t.float "f_3_score", default: 0.0
    t.float "f_4_score", default: 0.0
    t.float "f_5_score", default: 0.0
    t.float "f_6_score", default: 0.0
    t.float "f_7_score", default: 0.0
    t.integer "figure_id"
    t.boolean "notif_generated", default: false
    t.index ["figure_id"], name: "index_comments_on_figure_id"
    t.index ["reference_id"], name: "index_comments_on_reference_id"
    t.index ["timeline_id"], name: "index_comments_on_timeline_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contributor_comments", id: :serial, force: :cascade do |t|
    t.integer "comment_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_contributor_comments_on_comment_id"
    t.index ["user_id"], name: "index_contributor_comments_on_user_id"
  end

  create_table "contributor_frames", id: :serial, force: :cascade do |t|
    t.integer "frame_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frame_id"], name: "index_contributor_frames_on_frame_id"
    t.index ["user_id"], name: "index_contributor_frames_on_user_id"
  end

  create_table "contributor_summaries", id: :serial, force: :cascade do |t|
    t.integer "summary_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["summary_id"], name: "index_contributor_summaries_on_summary_id"
    t.index ["user_id"], name: "index_contributor_summaries_on_user_id"
  end

  create_table "credits", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.integer "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["summary_id"], name: "index_credits_on_summary_id"
    t.index ["timeline_id"], name: "index_credits_on_timeline_id"
    t.index ["user_id"], name: "index_credits_on_user_id"
  end

  create_table "dead_links", id: :serial, force: :cascade do |t|
    t.integer "reference_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reference_id"], name: "index_dead_links_on_reference_id"
    t.index ["user_id"], name: "index_dead_links_on_user_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by", limit: 255
    t.string "queue", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "domains", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edge_votes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "edge_id"
    t.boolean "value"
    t.index ["edge_id"], name: "index_edge_votes_on_edge_id"
    t.index ["user_id"], name: "index_edge_votes_on_user_id"
  end

  create_table "edges", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "target"
    t.integer "weight", default: 1
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "plus", default: 0
    t.integer "minus", default: 0
    t.integer "balance", default: 0
    t.index ["timeline_id"], name: "index_edges_on_timeline_id"
  end

  create_table "figures", id: :serial, force: :cascade do |t|
    t.integer "reference_id"
    t.integer "timeline_id"
    t.integer "user_id"
    t.boolean "profil"
    t.string "picture", limit: 255
    t.string "file_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "img_timeline_id"
    t.text "source", default: ""
    t.index ["reference_id"], name: "index_figures_on_reference_id"
    t.index ["timeline_id"], name: "index_figures_on_timeline_id"
    t.index ["user_id"], name: "index_figures_on_user_id"
  end

  create_table "frame_credits", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "user_id"
    t.integer "frame_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["frame_id"], name: "index_frame_credits_on_frame_id"
    t.index ["timeline_id"], name: "index_frame_credits_on_timeline_id"
    t.index ["user_id"], name: "index_frame_credits_on_user_id"
  end

  create_table "frames", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "user_id"
    t.text "name"
    t.text "content"
    t.text "name_markdown"
    t.text "content_markdown"
    t.float "score", default: 0.0
    t.integer "balance", default: 0
    t.boolean "best", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "binary", default: ""
    t.text "why", default: ""
    t.text "why_markdown", default: ""
    t.index ["timeline_id"], name: "index_frames_on_timeline_id"
    t.index ["user_id"], name: "index_frames_on_user_id"
  end

  create_table "go_patches", id: :serial, force: :cascade do |t|
    t.integer "comment_id"
    t.integer "user_id"
    t.integer "summary_id"
    t.integer "field"
    t.integer "target_user_id"
    t.integer "frame_id"
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "counter", default: 0
    t.integer "countdown", default: 0
    t.index ["comment_id"], name: "index_go_patches_on_comment_id"
    t.index ["frame_id"], name: "index_go_patches_on_frame_id"
    t.index ["summary_id"], name: "index_go_patches_on_summary_id"
    t.index ["user_id"], name: "index_go_patches_on_user_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "message"
    t.integer "timeline_id"
    t.integer "reference_id"
    t.text "target_email"
    t.text "target_name"
    t.text "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reference_id"], name: "index_invitations_on_reference_id"
    t.index ["timeline_id"], name: "index_invitations_on_timeline_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "issues", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "body"
    t.text "labels", default: [], array: true
    t.string "author", limit: 255
    t.integer "importance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "url", limit: 255
  end

  create_table "likes", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "links", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "comment_id"
    t.integer "reference_id"
    t.integer "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "count"
    t.index ["comment_id"], name: "index_links_on_comment_id"
    t.index ["reference_id"], name: "index_links_on_reference_id"
    t.index ["timeline_id"], name: "index_links_on_timeline_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "newsletters", id: :serial, force: :cascade do |t|
    t.text "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_selections", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "reference_id"
    t.integer "frame_id"
    t.integer "comment_id"
    t.integer "summary_id"
    t.integer "user_id"
    t.boolean "win"
    t.integer "field"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["comment_id"], name: "index_notification_selections_on_comment_id"
    t.index ["frame_id"], name: "index_notification_selections_on_frame_id"
    t.index ["reference_id"], name: "index_notification_selections_on_reference_id"
    t.index ["summary_id"], name: "index_notification_selections_on_summary_id"
    t.index ["timeline_id"], name: "index_notification_selections_on_timeline_id"
    t.index ["user_id"], name: "index_notification_selections_on_user_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.integer "reference_id"
    t.integer "summary_id"
    t.integer "comment_id"
    t.integer "like_id"
    t.integer "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "field"
    t.integer "frame_id"
    t.index ["comment_id"], name: "index_notifications_on_comment_id"
    t.index ["frame_id"], name: "index_notifications_on_frame_id"
    t.index ["like_id"], name: "index_notifications_on_like_id"
    t.index ["reference_id"], name: "index_notifications_on_reference_id"
    t.index ["summary_id"], name: "index_notifications_on_summary_id"
    t.index ["timeline_id"], name: "index_notifications_on_timeline_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "patch_messages", id: :serial, force: :cascade do |t|
    t.integer "go_patch_id"
    t.integer "user_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comment_id"
    t.integer "frame_id"
    t.integer "summary_id"
    t.text "message_markdown", default: ""
    t.index ["go_patch_id"], name: "index_patch_messages_on_go_patch_id"
    t.index ["user_id"], name: "index_patch_messages_on_user_id"
  end

  create_table "pending_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "why"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "refused", default: false
    t.index ["user_id"], name: "index_pending_users_on_user_id"
  end

  create_table "private_timelines", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["timeline_id"], name: "index_private_timelines_on_timeline_id"
    t.index ["user_id"], name: "index_private_timelines_on_user_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "title"
    t.text "title_markdown"
    t.text "content"
    t.text "content_markdown"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "score"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "ratings", id: :serial, force: :cascade do |t|
    t.integer "reference_id"
    t.integer "timeline_id"
    t.integer "user_id"
    t.integer "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reference_id"], name: "index_ratings_on_reference_id"
    t.index ["timeline_id"], name: "index_ratings_on_timeline_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "reference_contributors", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "reference_id"
    t.boolean "bool"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reference_id"], name: "index_reference_contributors_on_reference_id"
    t.index ["user_id"], name: "index_reference_contributors_on_user_id"
  end

  create_table "reference_edge_votes", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "reference_edge_id"
    t.boolean "value"
    t.integer "category"
    t.index ["reference_edge_id"], name: "index_reference_edge_votes_on_reference_edge_id"
    t.index ["timeline_id"], name: "index_reference_edge_votes_on_timeline_id"
    t.index ["user_id"], name: "index_reference_edge_votes_on_user_id"
  end

  create_table "reference_edges", id: :serial, force: :cascade do |t|
    t.integer "timeline_id"
    t.integer "reference_id"
    t.integer "target"
    t.integer "weight", default: 1
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "category"
    t.integer "plus", default: 0
    t.integer "minus", default: 0
    t.integer "balance", default: 0
    t.index ["reference_id"], name: "index_reference_edges_on_reference_id"
    t.index ["timeline_id"], name: "index_reference_edges_on_timeline_id"
    t.index ["user_id"], name: "index_reference_edges_on_user_id"
  end

  create_table "reference_taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reference_id"], name: "index_reference_taggings_on_reference_id"
    t.index ["tag_id"], name: "index_reference_taggings_on_tag_id"
  end

  create_table "reference_user_taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "reference_user_tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reference_user_tag_id"], name: "index_reference_user_taggings_on_reference_user_tag_id"
    t.index ["tag_id"], name: "index_reference_user_taggings_on_tag_id"
  end

  create_table "reference_user_tags", id: :serial, force: :cascade do |t|
    t.integer "reference_id"
    t.integer "timeline_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reference_id"], name: "index_reference_user_tags_on_reference_id"
    t.index ["timeline_id"], name: "index_reference_user_tags_on_timeline_id"
    t.index ["user_id"], name: "index_reference_user_tags_on_user_id"
  end

  create_table "references", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.text "doi"
    t.text "url"
    t.integer "year"
    t.text "title"
    t.text "title_fr"
    t.text "author"
    t.text "journal"
    t.text "publisher"
    t.boolean "open_access", default: true
    t.text "abstract", default: ""
    t.integer "nb_contributors", default: 0
    t.integer "nb_edits", default: 0
    t.integer "nb_votes", default: 0
    t.integer "star_1", default: 0
    t.integer "star_2", default: 0
    t.integer "star_3", default: 0
    t.integer "star_4", default: 0
    t.integer "star_5", default: 0
    t.integer "star_most", default: 0
    t.integer "binary_1", default: 0
    t.integer "binary_2", default: 0
    t.integer "binary_3", default: 0
    t.integer "binary_4", default: 0
    t.integer "binary_5", default: 0
    t.integer "binary_most", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "binary", limit: 255, default: ""
    t.boolean "article", default: true
    t.text "abstract_markdown", default: ""
    t.integer "category"
    t.string "slug", limit: 255
    t.integer "views", default: 0
    t.index ["slug"], name: "index_references_on_slug", unique: true
    t.index ["timeline_id"], name: "index_references_on_timeline_id"
    t.index ["user_id"], name: "index_references_on_user_id"
  end

  create_table "summaries", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.integer "balance", default: 0
    t.float "score"
    t.boolean "best", default: false
    t.text "content", default: ""
    t.text "markdown", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "public", default: true
    t.text "caption", default: ""
    t.text "caption_markdown", default: ""
    t.integer "figure_id"
    t.boolean "notif_generated", default: false
    t.index ["figure_id"], name: "index_summaries_on_figure_id"
    t.index ["timeline_id"], name: "index_summaries_on_timeline_id"
    t.index ["user_id"], name: "index_summaries_on_user_id"
  end

  create_table "summary_bests", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.integer "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["summary_id"], name: "index_summary_bests_on_summary_id"
    t.index ["timeline_id"], name: "index_summary_bests_on_timeline_id"
    t.index ["user_id"], name: "index_summary_bests_on_user_id"
  end

  create_table "summary_links", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.integer "reference_id"
    t.integer "summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "count"
    t.index ["reference_id"], name: "index_summary_links_on_reference_id"
    t.index ["summary_id"], name: "index_summary_links_on_summary_id"
    t.index ["timeline_id"], name: "index_summary_links_on_timeline_id"
    t.index ["user_id"], name: "index_summary_links_on_user_id"
  end

  create_table "tag_pairs", id: :serial, force: :cascade do |t|
    t.integer "tag_theme_source"
    t.integer "tag_theme_target"
    t.boolean "references"
    t.integer "occurencies"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["timeline_id"], name: "index_taggings_on_timeline_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timeline_choices", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.integer "choices", default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["timeline_id"], name: "index_timeline_choices_on_timeline_id"
    t.index ["user_id"], name: "index_timeline_choices_on_user_id"
  end

  create_table "timeline_contributors", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.boolean "bool"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["timeline_id"], name: "index_timeline_contributors_on_timeline_id"
    t.index ["user_id"], name: "index_timeline_contributors_on_user_id"
  end

  create_table "timelines", id: :serial, force: :cascade do |t|
    t.text "name"
    t.integer "user_id"
    t.integer "nb_references", default: 0
    t.integer "nb_contributors", default: 0
    t.integer "nb_likes", default: 0
    t.integer "nb_comments", default: 0
    t.integer "nb_summaries", default: 0
    t.float "score", default: 1.0
    t.float "score_recent", default: 1.0
    t.boolean "debate", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "binary", limit: 255, default: ""
    t.integer "nb_frames", default: 0
    t.text "frame", default: ""
    t.integer "figure_id"
    t.string "slug", limit: 255
    t.boolean "private", default: false
    t.boolean "staging", default: false
    t.integer "views", default: 0
    t.boolean "favorite", default: false
    t.index ["created_at"], name: "index_timelines_on_created_at"
    t.index ["slug"], name: "index_timelines_on_slug", unique: true
    t.index ["user_id"], name: "index_timelines_on_user_id"
  end

  create_table "user_details", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "institution", limit: 255
    t.string "job", limit: 255
    t.string "website", limit: 255
    t.text "biography"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "figure_id"
    t.text "content_markdown", default: ""
    t.boolean "send_email", default: true
    t.hstore "profil"
    t.integer "countdown", default: 15
    t.integer "frequency", default: 15
    t.index ["figure_id"], name: "index_user_details_on_figure_id"
    t.index ["user_id"], name: "index_user_details_on_user_id"
  end

  create_table "user_patches", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "go_patch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["go_patch_id"], name: "index_user_patches_on_go_patch_id"
    t.index ["user_id"], name: "index_user_patches_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.float "score", default: 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_digest", limit: 255
    t.string "remember_digest", limit: 255
    t.boolean "admin", default: false
    t.string "activation_digest", limit: 255
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest", limit: 255
    t.datetime "reset_sent_at"
    t.integer "important"
    t.integer "nb_notifs", default: 0
    t.boolean "can_switch_admin", default: false
    t.string "slug", limit: 255
    t.boolean "private_timeline", default: false
    t.integer "nb_private", default: 0
    t.integer "my_patches", default: 0
    t.integer "target_patches", default: 0
    t.text "first_name", default: ""
    t.text "last_name", default: ""
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "visite_references", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "counter", default: 0
    t.index ["reference_id"], name: "index_visite_references_on_reference_id"
    t.index ["user_id", "reference_id"], name: "index_visite_references_on_user_id_and_reference_id", unique: true
    t.index ["user_id"], name: "index_visite_references_on_user_id"
  end

  create_table "visite_timelines", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "counter", default: 0
    t.index ["timeline_id"], name: "index_visite_timelines_on_timeline_id"
    t.index ["user_id", "timeline_id"], name: "index_visite_timelines_on_user_id_and_timeline_id", unique: true
    t.index ["user_id"], name: "index_visite_timelines_on_user_id"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.integer "reference_id"
    t.integer "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "field"
    t.index ["comment_id"], name: "index_votes_on_comment_id"
    t.index ["reference_id"], name: "index_votes_on_reference_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "contributor_comments", "comments"
  add_foreign_key "contributor_comments", "users"
  add_foreign_key "contributor_frames", "frames"
  add_foreign_key "contributor_frames", "users"
  add_foreign_key "contributor_summaries", "summaries"
  add_foreign_key "contributor_summaries", "users"
  add_foreign_key "patch_messages", "go_patches"
  add_foreign_key "patch_messages", "users"
  add_foreign_key "user_patches", "go_patches"
  add_foreign_key "user_patches", "users"
end
