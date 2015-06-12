class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.references :timeline, index: true
      t.integer :target
      t.integer :weight, default: 1
      t.references :user

      t.timestamps
    end
  end
end
