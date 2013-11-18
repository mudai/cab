class CreateLoginHistories < ActiveRecord::Migration
  def change
    # TODO: パーティショニングする
    create_table :login_histories do |t|
      t.integer :user_id
      t.string :ip_address # リクエスト元IPアドレス
      t.string :user_agent # ユーザーエージェント
      t.datetime :logged_in_at # ログイン日付
      t.timestamps
    end

    add_index :login_histories, :user_id
  end
end
