class CreatePasswordHistories < ActiveRecord::Migration
  def change
    create_table :password_histories do |t|
      t.integer :user_id
      t.string :before_password_digest # 変更前ログインID
      t.datetime :changed_at # 変更日付
      t.timestamps
    end

    add_index :password_histories, :user_id
  end
end
