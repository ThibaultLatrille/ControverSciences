class CreateNewTimelines < ActiveRecord::Migration
  def change
    create_table :new_timelines do |t|
      t.references :timeline, index: true

      t.timestamps
    end
  end
end
