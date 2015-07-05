class ReferenceEdgeMOdification < ActiveRecord::Migration
  def change
    change_table :reference_edge_votes do |t|
      t.references :reference_edge, index: true
      t.boolean :value
    end
    remove_column :reference_edge_votes, :target
    remove_column :reference_edge_votes, :reference_id
    remove_column :reference_edge_votes, :reversible
    add_column :reference_edges, :best, :boolean, default: false
    add_column :reference_edges, :category, :integer
  end
end
