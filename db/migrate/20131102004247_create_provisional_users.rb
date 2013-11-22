class CreateProvisionalUsers < ActiveRecord::Migration
  def change
    create_table :provisional_users do |t|
      t.integer :organization_id
      t.integer :subscriber_information_id
      t.integer :onetime_token_id # 最新のtoken_idにupdateして過去のtokenは無効にする
      t.boolean :status # 仮登録状態かどうか
      t.string :family_name # 名字
      t.string :first_name # 名前
      t.string :family_name_kana
      t.string :first_name_kana
      t.string :code # 記号
      t.string :number # 番号
      t.date :birthday # 生年月日
      t.string :email # 一応権限確認時のデータを持っておく
      t.string :login_id # login_idチェックのときに userテーブルのlogin_idと申し込み中のlogin_idをチェックする
      t.string :password_digest # ユーザーテーブル作成時にcopyする
      t.string :nickname # ニックネーム
      t.timestamps
    end

    add_index :provisional_users, [:organization_id, :onetime_token_id], name: "index_prov_users_on_org_id_and_onetime_token_id"
    add_index :provisional_users, [:organization_id, :subscriber_information_id], name: "index_prov_users_on_org_id_and_subscriber_info_id"
  end
end
