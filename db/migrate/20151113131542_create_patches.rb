class CreatePatches < ActiveRecord::Migration
  def change
    create_table :patches do |t|
      t.references :comment, index: true
      t.references :user, index: true
      t.references :summary, index: true
      t.integer :field
      t.integer :target_user_id, index: true
      t.references :frame, index: true
      t.text :content

      t.timestamps
    end
  end
end
