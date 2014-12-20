class CreateVisiteTimelines < ActiveRecord::Migration
  def change
    create_table :visite_timelines do |t|
      t.references :user, index: true
      t.references :timeline, index: true

      t.timestamps
    end
    add_index :visite_timelines, [:user_id, :timeline_id], unique: true
  end
end
