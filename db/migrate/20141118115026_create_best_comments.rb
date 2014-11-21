class CreateBestComments < ActiveRecord::Migration
  def change
    create_table :best_comments do |t|
      t.references :user, index: true
      t.references :reference, index: true
      t.integer :field
      t.references :comment, index: true

      t.timestamps
    end
  end
end
