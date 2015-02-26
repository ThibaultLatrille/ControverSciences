class CreateCommentTypes < ActiveRecord::Migration
  def change
    create_table :comment_types do |t|
      t.references :comment, index: true
      t.references :user, index: true
      t.integer :target_user_id, index: true
      t.text :content

      t.timestamps
    end
  end
end
