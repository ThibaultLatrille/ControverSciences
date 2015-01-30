class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.references :reference, index: true
      t.integer :balance, default: 0
      t.float :score, default: 0.0
      t.boolean :best, default: false
      t.text :f_0_content, default: ''
      t.text :f_1_content, default: ''
      t.text :f_2_content, default: ''
      t.text :f_3_content, default: ''
      t.text :f_4_content, default: ''
      t.text :f_5_content, default: ''
      t.text :markdown_0
      t.text :markdown_1
      t.text :markdown_2
      t.text :markdown_3
      t.text :markdown_4
      t.text :markdown_5

      t.timestamps
    end
  end
end
