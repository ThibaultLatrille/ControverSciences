class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.references :timeline, index: true
      t.references :user, index: true
      t.text :name
      t.text :content
      t.text :name_markdown
      t.text :content_markdown
      t.float :score
      t.integer :balance
      t.boolean :best, default: false

      t.timestamps
    end
  end
end
