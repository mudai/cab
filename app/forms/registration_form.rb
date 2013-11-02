# -*- coding: utf-8 -*-
#
class RegistrationForm
  include ActiveModel::Model

  # TODO: バリデーション

  attr_accessor :host, :code, :number, :family_name_kana, :first_name_kana,
    :birthday, :login_id, :password, :password_confirmation, :nickname, :email, :email_confirmation

  def persisted?
    false
  end

  def initialize(host, params = {})
    self.host = host
    params.try(:each) do |name, value|
      send("#{name}=", value) rescue nil
    end
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
