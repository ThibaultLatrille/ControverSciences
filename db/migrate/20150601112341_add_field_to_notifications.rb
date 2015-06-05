class AddFieldToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :field, :integer, default: nil
  end
end
