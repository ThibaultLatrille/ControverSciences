class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.text :name
      t.references :user, index: true
      t.integer :nb_references, default: 0
      t.integer :nb_contributors, default: 0
      t.integer :nb_likes, default: 0
      t.integer :nb_edits, default: 0
      t.float :score, index: true, default: 1.0
      t.float :score_recent, index: true, default: 1.0
      t.timestamps
    end
    add_index :timelines, [:created_at]
  end
end
