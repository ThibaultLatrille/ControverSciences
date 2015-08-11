class AddPrivateTimeline < ActiveRecord::Migration
  def change
    add_column :users, :private_timeline, :boolean, default: false
    add_column :timelines, :private, :boolean, default: false
  end
end
