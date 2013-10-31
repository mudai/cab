class CreateSubscriberInformations < ActiveRecord::Migration
  def change
    # 健保加入者情報を管理するテーブル
    create_table :subscriber_informations do |t|

      t.timestamps
    end
  end
end
