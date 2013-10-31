class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name # 表示用名称
      t.string :full_name # 正式名称
      t.string :host
      t.timestamps
    end
  end
end
