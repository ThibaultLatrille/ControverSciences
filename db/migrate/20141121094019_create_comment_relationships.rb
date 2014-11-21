class CreateCommentRelationships < ActiveRecord::Migration
  def change
    create_table :comment_relationships do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
  end
end
