class CreateCommentJoins < ActiveRecord::Migration
  def change
    create_table :comment_joins do |t|
      t.references :reference, index: true
      t.references :comment, index: true
      t.integer :field

      t.timestamps
    end
  end
end
