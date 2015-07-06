class CreateUserProfils < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    add_column :user_details, :profil, :hstore
    add_column :users, :my_typos, :integer, default: 0
    add_column :users, :target_typos, :integer, default: 0
  end
end
