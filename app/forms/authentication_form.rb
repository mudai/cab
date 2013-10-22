# -*- coding: utf-8 -*-
#
class AuthenticationForm
  include ActiveModel::Model

  attr_accessor :org_dir, :login_id, :password
  # カスタムバリデータで認証チェックを行う
  attr_reader :user

  def persisted?
    false
  end

  def initialize(params = {})
    self.org_dir = params[:org_dir]
    self.login_id = params[:login_id]
    self.password = params[:password]
  end

  # ログインボタンを押されたときの処理
  def submit
    auth = AuthenticationService.new(org_dir, login_id, password)

    # org_dir, login_id, passwordの入力チェック, 認証可能かどうか
    if valid? && auth.authenticate?
      @user = auth.user
      auth.after_authenticate!
      true
    else # 入力チェックエラーの場合は一律のエラーメッセージをコントローラー側で出す
      false
    end
  end
end
