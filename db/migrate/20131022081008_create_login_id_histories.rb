class CreateLoginIdHistories < ActiveRecord::Migration
  def change
    create_table :login_id_histories do |t|
      t.integer :user_id
      t.string :before_login_id # 変更前ログインID
      t.datetime :changed_at # 変更日付
      t.timestamps
    end

    add_index :login_id_histories, :user_id
  end
end
