class AddCategoryToReferences < ActiveRecord::Migration
  def change
    add_column :references, :category, :integer
  end
end
