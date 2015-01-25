class CreateNewCommentSelections < ActiveRecord::Migration
  def change
    create_table :new_comment_selections do |t|
      t.integer :old_comment
      t.integer :new_comment

      t.timestamps
    end
  end
end
