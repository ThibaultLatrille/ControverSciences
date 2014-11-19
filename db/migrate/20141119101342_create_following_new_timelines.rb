class CreateFollowingNewTimelines < ActiveRecord::Migration
  def change
    create_table :following_new_timelines do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
