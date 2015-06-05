class RenamedNotifications < ActiveRecord::Migration
  def change
    drop_table :following_timelines
    drop_table :following_new_timelines
    drop_table :following_references
    drop_table :following_summaries
    drop_table :notification_timelines
    drop_table :notification_references
    drop_table :notification_summaries
    drop_table :notification_comments
    drop_table :notification_selections
    drop_table :notification_summary_selections
    change_table :likes do |t|
      t.references :user, index: true
      t.remove :ip
    end
    create_table :notifications do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.references :reference, index: true
      t.references :summary, index: true
      t.references :comment, index: true
      t.references :like, index: true
      t.integer :type, index: true

      t.timestamps
    end
  end
end
