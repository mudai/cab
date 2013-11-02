class CreateMailTemplates < ActiveRecord::Migration
  def change
    create_table :mail_templates do |t|
      t.integer :organization_id
      t.string :code
      t.string :subject
      t.text :body
      t.timestamps
    end
  end
end
