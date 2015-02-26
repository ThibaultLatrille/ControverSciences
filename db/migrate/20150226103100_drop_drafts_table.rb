class DropDraftsTable < ActiveRecord::Migration
  def change
    drop_table :summary_drafts
    drop_table :comment_drafts
  end
end
