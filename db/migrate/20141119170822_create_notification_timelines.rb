class CreateNotificationTimelines < ActiveRecord::Migration
  def change
    create_table :notification_timelines do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
