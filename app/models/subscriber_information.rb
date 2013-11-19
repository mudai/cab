class SubscriberInformation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  has_many :provisional_users

  # where or all スコープの中から適用情報が一致するユーザーを取り出す
  def self.search(code: code, number: number, birthday: birthday, family_name_kana: family_name_kana, first_name_kana: first_name_kana)
    scope = self
    scope = scope.where(code: code, number: number, birthday: birthday) # indexの効く部分で絞り込む

    # 文字列を揃えマッチング
    info = scope.to_a.find do |x|
      convert_kana(x.family_name_kana) == convert_kana(family_name_kana) &&
        convert_kana(x.first_name_kana) == convert_kana(first_name_kana)
    end

    info
  end

  private
  # そのうちモジュールに切り出してextendする
  def self.convert_kana(str)
    return "" if str.blank?
    NKF.nkf("-w8Z4x", str).tr("ｧｨｩｪｫｯｬｭｮ","ｱｲｳｴｵﾂﾔﾕﾖ").tr("ﾞ","").tr("ﾁｽ","ｼﾂ")
  end
end
