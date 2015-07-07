class Canswithadmin < ActiveRecord::Migration
  def change
    add_column :users, :can_switch_admin, :boolean, default: false
  end
end
