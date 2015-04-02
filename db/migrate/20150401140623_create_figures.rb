class CreateFigures < ActiveRecord::Migration
  def change
    create_table :figures do |t|
      t.references :reference, index: true
      t.references :timeline, index: true
      t.references :user, index: true
      t.boolean :profil
      t.string :picture
      t.string :file_name

      t.timestamps
    end
  end
end
