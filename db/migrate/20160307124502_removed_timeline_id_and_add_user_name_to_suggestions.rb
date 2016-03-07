class RemovedTimelineIdAndAddUserNameToSuggestions < ActiveRecord::Migration
  def change
    remove_column :suggestions, :timeline_id
    add_column :suggestions, :name, :text, default: ''
    add_column :suggestion_children, :name, :text, default: ''
  end
end
