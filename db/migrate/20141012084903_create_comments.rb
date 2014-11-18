class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.references :reference, index: true
      t.integer :field
      t.text :content
      t.integer :votes_plus, default: 0
      t.integer :votes_minus, default: 0
      t.float :score, default: 0.0
      t.float :score_recent, default: 0.0

      t.timestamps
    end
  end
end
