class CreateProvisionalUsers < ActiveRecord::Migration
  def change
    create_table :provisional_users do |t|
      t.integer :onetime_token_id # 最新のtoken_idにupdateして過去のtokenは無効にする
      t.boolean :status # 仮登録状態かどうか
      t.string :email # 一応権限確認時のデータを持っておく
      t.string :login_id # login_idチェックのときに userテーブルのlogin_idと申し込み中のlogin_idをチェックする
      t.string :password_digest # ユーザーテーブル作成時にcopyする
      t.string :nickname # ニックネーム
      t.timestamps
    end

    add_index :provisional_users, :onetime_token_id
  end
end
