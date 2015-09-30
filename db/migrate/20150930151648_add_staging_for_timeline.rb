class AddStagingForTimeline < ActiveRecord::Migration
  def change
    add_column :timelines, :staging, :boolean, default: false
    add_column :timelines, :views, :integer, default: 0
    add_column :references, :views, :integer, default: 0
    add_column :timelines, :favorite, :boolean, default: false
  end
end
