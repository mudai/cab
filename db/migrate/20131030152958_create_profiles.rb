class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :nickname # ニックネーム
      t.timestamps
    end

    add_index :profiles, :user_id
  end
end
