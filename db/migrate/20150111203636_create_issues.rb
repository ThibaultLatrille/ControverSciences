class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title
      t.text :body
      t.text :labels, array: true, default: []
      t.string :author
      t.integer :importance

      t.timestamps
    end
  end
end
