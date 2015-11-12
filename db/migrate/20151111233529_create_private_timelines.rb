class CreatePrivateTimelines < ActiveRecord::Migration
  def change
    create_table :private_timelines do |t|
      t.references :user, index: true
      t.references :timeline, index: true

      t.timestamps
    end
  end
end
