class RemoveNameTosuggestion < ActiveRecord::Migration
  def change
    change_table :suggestions do |t|
      t.remove :email
      t.remove :name
    end
    change_table :suggestion_children do |t|
      t.remove :email
      t.remove :name
    end
  end
end
