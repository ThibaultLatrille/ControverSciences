class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.references :user, index: true
      t.string :institution
      t.string :job
      t.string :website
      t.text :biography

      t.timestamps
    end
  end
end
