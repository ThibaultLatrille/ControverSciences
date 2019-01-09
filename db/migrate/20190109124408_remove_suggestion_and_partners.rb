class RemoveSuggestionAndPartners < ActiveRecord::Migration[5.2]
  def change
    drop_table :locations
    drop_table :suggestions
    drop_table :suggestion_votes
    drop_table :suggestion_children
    drop_table :suggestion_child_votes
    remove_column :notifications, :suggestion_id
    remove_column :notifications, :suggestion_child_id
    drop_table :partners
    drop_table :partner_loves
    remove_column :figures, :partner_id
  end
end
