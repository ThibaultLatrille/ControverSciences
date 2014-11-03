class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.text :name
      t.references :user, index: true
      t.integer :timeline_edit_id
      t.text :timeline_edit_content
      t.integer :timeline_edit_votes, default: 0
      t.text :timeline_edit_username
      t.integer :nb_references, default: 0
      t.integer :nb_contributors, default: 0
      t.integer :nb_votes, default: 0
      t.integer :nb_votes_star, default: 0
      t.integer :nb_edits, default: 0
      t.float :rank, index: true, default: 0
      t.timestamps
    end
    add_index :timelines, [:created_at]
  end
end
