class AddCountDownForNotifications < ActiveRecord::Migration
  def change
    add_column :user_details, :frequency, :integer, default: 15
  end
end
