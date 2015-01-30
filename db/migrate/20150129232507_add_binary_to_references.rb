class AddBinaryToReferences < ActiveRecord::Migration
  def change
    add_column :references, :binary, :string, default: ''
  end
end
