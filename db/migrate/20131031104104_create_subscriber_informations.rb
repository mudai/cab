class CreateSubscriberInformations < ActiveRecord::Migration
  def change
    # 健保加入者情報を管理するテーブル
    create_table :subscriber_informations do |t|
      t.integer :organization_id
      t.integer :user_id
      t.string :family_name # 名字
      t.string :first_name # 名前
      t.string :family_name_kana
      t.string :first_name_kana
      t.string :code # 記号
      t.string :number # 番号
      t.date :birthday # 生年月日
      t.datetime :associated_at # ひも付け日時
      t.timestamps
    end
  end
end
