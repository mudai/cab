class SubscriptionValidator < ActiveModel::Validator
  def validates(r)
    org = ::Organization.find_by(host: r.host) # hostが存在することは他のバリデータで行う
    subscriptions = org.subscriber_informations.where(code: r.code, number: r.number, birthday: r.birthday)
    if subscriptions.count == 0
      # 適用データが見つかりませんエラー
    end

    unless subscription = subscriptions.to_a.find {|x|
      convert_kana(x.family_name_kana) == convert_kana(r.family_name_kana) && convert_kana(x.first_name_kana) == convert_kana(r.first_name_kana)
    }
    # 適用データが見つかりません。
    end

    if subscription.user.present?
      # この適用情報で既にサインアップ済み

    end
  end

  private
  def convert_kana(str)
    return "" if str.blank?
    NKF.nkf("-w8Z4x", str).tr("ｧｨｩｪｫｯｬｭｮ","ｱｲｳｴｵﾂﾔﾕﾖ").tr("ﾞ","").tr("ﾁｽ","ｼﾂ")
  end
end
