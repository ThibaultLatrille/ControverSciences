class CreateSummaryRelationships < ActiveRecord::Migration
  def change
    create_table :summary_relationships do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
  end
end
