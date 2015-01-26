class CreateNewCommentSelections < ActiveRecord::Migration
  def change
    create_table :new_comment_selections do |t|
      t.integer :old_comment_id
      t.integer :new_comment_id

      t.timestamps
    end
  end
end
