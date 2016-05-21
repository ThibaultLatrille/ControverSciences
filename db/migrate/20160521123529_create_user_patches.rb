class CreateUserPatches < ActiveRecord::Migration
  def change
    create_table :user_patches do |t|
      t.references :user, index: true, foreign_key: true
      t.references :go_patch, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
