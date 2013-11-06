class CreateOnetimeTokens < ActiveRecord::Migration
  def change
    create_table :onetime_tokens do |t|
      t.integer :organization_id
      t.integer :user_id # ユーザー登録時はnull
      t.boolean :status # true: 有効, false: 無効
      t.string :token_type # registration, email_change, password_reset, login_id_reset
      t.string :token
      t.datetime :expired_at # 有効期限
      t.timestamps
    end

    add_index :onetime_tokens, [:organization_id, :token]
  end
end
