class SubscriptionValidator < ActiveModel::Validator
  def validate(r)
    org = ::Organization.find_by(host: r.host) # hostが存在することは他のバリデータで行う

    info = org.subscriber_informations.search(
      code: r.code,
      number: r.number,
      birthday: r.birthday,
      family_name_kana: r.family_name_kana,
      first_name_kana: r.first_name_kana 
    )

    if info.nil?
      message = I18n.t('activerecord.errors.messages.not_found')
      r.errors.add(:subscriber_information, message)
    end

    if info.try(:user).try(:present?)
      # この適用情報で既にサインアップ済み
      message = I18n.t('activerecord.errors.messages.already_used')
      r.errors.add(:subscriber_information, message)
    end
  end
end
