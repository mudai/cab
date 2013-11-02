class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :organization_id
      t.string :type
      t.timestamps
    end
  end
end
