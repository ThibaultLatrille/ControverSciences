class AddUrlToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :url, :string
  end
end
