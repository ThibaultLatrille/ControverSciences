class AddSlugToReferences < ActiveRecord::Migration
  def change
    add_column :references, :slug, :string
    add_index :references, :slug, unique: true
  end
end
