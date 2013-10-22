class AuthenticationForm
  include ActiveModel::Model

  attr_accessor :org_dir, :login_id, :password
  # カスタムバリデータで認証チェックを行う
  attr_reader :user

  def persisted?
    false
  end

  # ログインボタンを押されたときの処理
  def submit(params)
    self.org_dir = params[:org_dir]
    self.login_id = params[:login_id]
    self.password = params[:password]
    auth = AuthenticationService.new(org_dir, login_id, password)

    # login_id, passwordの入力チェック, 認証可能かどうか
    if valid? && auth.authenticate?
      @user = auth.user
      # TODO: ログインログ書き込み等の処理をこの辺に入れる
      true
    else # 入力チェックエラーの場合は一律のエラーメッセージを出す
      false
    end
  end
end
