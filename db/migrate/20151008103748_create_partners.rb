class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.references :user, index: true
      t.text :name
      t.text :url
      t.text :description
      t.text :why
      t.text :name_markdown
      t.text :description_markdown
      t.text :why_markdown
      t.integer :figure_id

      t.timestamps
    end
    change_table :figures do |t|
      t.integer :partner_id, index: true
    end
  end
end
