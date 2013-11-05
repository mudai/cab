# -*- coding: utf-8 -*-
#
class RegistrationForm
  include ActiveModel::Model
  include MultiParameterAttributes

  # TODO: バリデーション
  validates_with SubscriptionValidator # code, number, birthday, family_name_kana, first_name_kana これはこのバリデータに任せる
  validates :host, presence: true
  # validates :login_id, precence: true, uniqueness: {scope: :organization} # カスタムバリデータに変更する

  attr_accessor :host, :code, :number, :family_name_kana, :first_name_kana,
    :birthday, :login_id, :password, :password_confirmation, :nickname, :email, :email_confirmation

  def self.keys
    # Date, DateTime, Time以外は不要
    # multi_parameterをキャストするために必要
    # TODO: classマクロにそのうち変更する
    {
      host: String,
      code: String,
      number: String,
      family_name_kana: String,
      first_name_kana: String,
      birthday: Date,
      login_id: String,
      password: String,
      password_confirmation: String,
      nickname: String,
      email: String,
      email_confirmation: String
    }
  end

  def initialize(host, params = {})
    self.host = host
    self.attributes = params
  end

  def attributes
    Hash[instance_variable_names.map{|v| [v[1..-1].to_sym, instance_variable_get(v)]}]
  end

  # ログインボタンを押されたときの処理
  def submit
    provisional = RegistrationService::Provisional.new(attributes)

    if valid? && provisional.regist # パラメータのバリデーション＆権限チェックと仮登録レコードの作成
     
      token = provisional.signup_token # 登録が問題なければtokenが発行される
      User::Registrations::ProvisionalMailer.provisional_mail(
        attributes.merge(token: token)
      ).deliver

      true
    else # 入力チェックエラーの場合は一律のエラーメッセージをコントローラー側で出す
      false
    end
  end

  private

end
