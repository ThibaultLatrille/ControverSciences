class AddChildrenToSuggestion < ActiveRecord::Migration
  def change
    add_column :suggestions, :children, :integer, default: 0
  end
end
