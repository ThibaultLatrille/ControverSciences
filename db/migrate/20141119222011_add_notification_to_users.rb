class AddNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications_timeline, :integer, default: 0
    add_column :users, :notifications_reference, :integer, default: 0
    add_column :users, :notifications_comment, :integer, default: 0
    add_column :users, :notifications_selection, :integer, default: 0
    add_column :users, :notifications_win, :integer, default: 0
    add_column :users, :notifications_loss, :integer, default: 0
  end
end
