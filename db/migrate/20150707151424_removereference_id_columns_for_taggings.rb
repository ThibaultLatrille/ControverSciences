class RemovereferenceIdColumnsForTaggings < ActiveRecord::Migration
  def change
    remove_column :reference_user_taggings, :reference_id
  end
end
