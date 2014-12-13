class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.integer :balance
      t.float :score
      t.boolean :best
      t.text :content
      t.text :markdown

      t.timestamps
    end
  end
end
