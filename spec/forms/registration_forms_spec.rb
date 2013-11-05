require "spec_helper"

describe "バリデーション" do
  context "host" do
    xit "必須であること"
  end
  context "適用" do
    xit "データがあるかどうか"
  end
  context "login_id" do
    xit "必須"
    xit "4文字以上255文字以下"
  end
  context "password" do
    xit "確認と一致していること"
    xit "4文字以上255文字以下"
  end
  context "nickname" do
    xit "1文字以上255文字以下"
  end
  context "email" do
    xit "確認と一致していること"
    xit "emailフォーマットであること"
  end

end
