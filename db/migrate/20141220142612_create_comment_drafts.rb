class CreateCommentDrafts < ActiveRecord::Migration
  def change
    create_table :comment_drafts do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.references :reference, index: true
      t.integer :parent_id
      t.text :f_1_content
      t.text :f_2_content
      t.text :f_3_content
      t.text :f_4_content
      t.text :f_5_content

      t.timestamps
    end
  end
end
