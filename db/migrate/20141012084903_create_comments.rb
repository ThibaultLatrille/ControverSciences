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
      t.text :f_1_content
      t.text :f_2_content
      t.text :f_3_content
      t.text :f_4_content
      t.text :f_5_content
      t.text :markdown_1
      t.text :markdown_2
      t.text :markdown_3
      t.text :markdown_4
      t.text :markdown_5

      t.timestamps
    end
  end
end
