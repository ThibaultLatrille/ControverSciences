class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.text :name
      t.references :user, index: true
      t.integer :timeline_edit_id
      t.text :timeline_edit_content
      t.integer :timeline_edit_votes
      t.text :timeline_edit_username
      t.integer :nb_references
      t.integer :nb_contributors
      t.integer :nb_votes
      t.integer :nb_edits
      t.float :rank, index: true

      t.timestamps
    end
  end
end
