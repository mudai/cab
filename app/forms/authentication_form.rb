# -*- coding: utf-8 -*-
#
class AuthenticationForm
  include ActiveModel::Model

  attr_accessor :login_id, :password
  # カスタムバリデータで認証チェックを行う
  attr_reader :user

  def initialize(params = {})
    self.login_id = params[:login_id]
    self.password = params[:password]
  end

  # ログインボタンを押されたときの処理
  def submit
    # 団体ごとに認証パラメータが違う場合は、実装をコマンドパターンとかにする
    auth = AuthenticationService.new(login_id, password)

    # org_dir, login_id, passwordの入力チェック, 認証可能かどうか
    if valid? && auth.authenticate?
      @user = auth.user
      true
    else # 入力チェックエラーの場合は一律のエラーメッセージをコントローラー側で出す
      false
    end
  end
end
