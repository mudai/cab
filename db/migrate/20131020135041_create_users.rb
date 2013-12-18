class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :organization_id
      t.string :login_id # ログインID
      t.string :password_digest # 暗号化済みパスワード
      t.datetime :first_logged_in_at # 初回ログイン日時
      t.datetime :last_logged_in_at # 最終ログイン日時
      t.timestamps
    end

    add_index :users, [:organization_id, :login_id], unique: true
  end
end
