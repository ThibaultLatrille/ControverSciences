class AddmarkdownForReferenceAbstract < ActiveRecord::Migration
  def change
    add_column :references, :abstract_markdown, :text, :default => ""
  end
end
