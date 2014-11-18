class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.float :score, default: 1.0

      t.timestamps
    end
  end
end
