class CreatePatchMessages < ActiveRecord::Migration
  def change
    create_table :patch_messages do |t|
      t.references :go_patch, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :message

      t.timestamps null: false
    end
  end
end
