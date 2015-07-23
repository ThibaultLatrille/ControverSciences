class AddSourceForFigure < ActiveRecord::Migration
  def change
    add_column :figures, :source, :text, :default => ""
  end
end
