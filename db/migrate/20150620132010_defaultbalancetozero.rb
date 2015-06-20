class Defaultbalancetozero < ActiveRecord::Migration
  def change
    change_column_default :frames, :balance, 0
    change_column_default :frames, :score, 0.0
    drop_table :new_comments
    drop_table :new_comment_selections
    drop_table :new_references
    drop_table :new_summaries
    drop_table :new_summary_selections
    drop_table :new_timelines
  end
end
