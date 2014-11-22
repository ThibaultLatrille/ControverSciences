class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.references :reference, index: true
      t.text :content
      t.integer :votes_plus, default: 0
      t.integer :votes_minus, default: 0
      t.integer :balance, default: 0
      t.float :score, default: 0.0
      t.boolean :best, default: false
      t.text :content_1
      t.text :content_2
      t.text :content_3
      t.text :content_4
      t.text :content_5
      t.text :markdown_1
      t.text :markdown_2
      t.text :markdown_3
      t.text :markdown_4
      t.text :markdown_5

      t.timestamps
    end
  end
end
