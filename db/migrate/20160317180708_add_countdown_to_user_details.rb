class AddCountdownToUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :countdown, :integer, default: 15
  end
end
