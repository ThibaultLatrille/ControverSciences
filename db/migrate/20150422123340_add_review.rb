class AddReview < ActiveRecord::Migration
  def change
    add_column :references, :article, :boolean, default: true
  end
end
