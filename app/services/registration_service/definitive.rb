class RegistrationService::Definitive
  # 本登録時に別セッションで二重登録ができないようにする
  attr_accessor :host, :token

  def initialize(attributes = {}) # TODO: active modelをインクルードして取っ払う？
    attributes.try(:each) do |name, value|
      send("#{name}=", value) rescue nil
    end
  end

  def confirm
    org = Organization.find_by(host: host)
    onetime_token = org.onetime_tokens.find_by(token: token, token_type: "registration", status: true)
    if onetime_token.expired_at >= Time.now # 有効期間内
      # tokenから仮登録ユーザーを引いて、userを作成する
      # ユーザーの作成が問題なければ他のtokenを無効化する
    else # 有効期間外
      # 有効期間外であればstatus: falseに変更する

    end
  end

  def confirmed_user
    # confirmを押下して問題なければ対象ユーザーが取得できる
  end

end
