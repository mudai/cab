require "spec_helper"

describe "バリデーション" do
  context "host" do
    it "必須であること" do
      RegistrationForm.new.should have(1).errors_on(:host)
    end
  end
  context "適用" do
    xit "データがあるかどうか" do
    end
  end
  context "login_id" do
    it "必須" do
      RegistrationForm.new.should have(2).errors_on(:login_id)
    end
    it "4文字以上255文字以下" do
      RegistrationForm.new(login_id: "123").should have(1).errors_on(:login_id)
      RegistrationForm.new(login_id: "1"*255).should_not have(1).errors_on(:login_id)
      RegistrationForm.new(login_id: "1"*256).should have(1).errors_on(:login_id)
    end
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
