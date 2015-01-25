class CreateNewComments < ActiveRecord::Migration
  def change
    create_table :new_comments do |t|
      t.references :comment, index: true

      t.timestamps
    end
  end
end
