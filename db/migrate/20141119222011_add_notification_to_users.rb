class AddNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications_timeline, :integer
    add_column :users, :notifications_reference, :integer
    add_column :users, :notifications_comment, :integer
  end
end
