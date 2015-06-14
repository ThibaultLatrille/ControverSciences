class CreateTypos < ActiveRecord::Migration
  def change
    create_table :typos do |t|
      t.references :user, index: true
      t.references :summary, index: true
      t.references :comment, index: true
      t.integer :field
      t.integer :target_user_id, index: true
      t.text :content

      t.timestamps
    end
    drop_table :comment_types
  end
end
