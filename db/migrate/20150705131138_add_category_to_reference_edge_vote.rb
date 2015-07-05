class AddCategoryToReferenceEdgeVote < ActiveRecord::Migration
  def change
    add_column :reference_edge_votes, :category, :integer
    remove_column :reference_edges, :best
  end
end
