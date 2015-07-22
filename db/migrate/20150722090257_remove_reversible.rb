class RemoveReversible < ActiveRecord::Migration
  def change
    remove_column :edges, :reversible
    remove_column :reference_edges, :reversible
  end
end
