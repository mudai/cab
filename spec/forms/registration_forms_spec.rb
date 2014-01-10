require "spec_helper"

describe "バリデーション" do
  context "host" do
    it "必須であること" do
      RegistrationForm.new.should have(1).errors_on(:host)
    end
  end
  context "適用" do
    before do
      @org = FactoryGirl.create(:organization)
      @subscriber_information = FactoryGirl.create(:subscriber_information, organization: @org)
      @user = FactoryGirl.create(:user, organization: @org)
    end
    it "データがあるかどうか" do
      param = {"host" => "www.qupio.com", "code"=>"muta", "number"=>"takaaki", "family_name"=>"牟田", "first_name"=>"孝明", "family_name_kana"=>"ムタ", "first_name_kana"=>"タカアキ", "birthday(1i)"=>"1984", "birthday(2i)"=>"8", "birthday(3i)"=>"17", "login_id" => "testtest", "password" => "password", "password_confirmation" => "password", "nickname" => "nickname", "email" => "takaaki.muta@gmail.com", "email_confirmation" => "takaaki.muta@gmail.com"}
      RegistrationForm.new(param).should be_valid
    end
    it "間違っている場合はデータはなし" do
      param = {"host" => "www.qupio.com", "code"=>"mutamuta", "number"=>"takaaki", "family_name"=>"牟田", "first_name"=>"孝明", "family_name_kana"=>"ムタ", "first_name_kana"=>"タカアキ", "birthday(1i)"=>"1984", "birthday(2i)"=>"8", "birthday(3i)"=>"17", "login_id" => "testtest", "password" => "password", "password_confirmation" => "password", "nickname" => "nickname", "email" => "takaaki.muta@gmail.com", "email_confirmation" => "takaaki.muta@gmail.com"}
      RegistrationForm.new(param).should_not be_valid
    end
  end

  context "login_id" do
    it "必須" do
      RegistrationForm.new.should have(2).errors_on(:login_id)
    end
    it "5文字以上255文字以下" do
      RegistrationForm.new(login_id: "123").should have(1).errors_on(:login_id)
      RegistrationForm.new(login_id: "1234").should have(0).errors_on(:login_id)
      RegistrationForm.new(login_id: "1"*255).should have(0).errors_on(:login_id)
      RegistrationForm.new(login_id: "1"*256).should have(1).errors_on(:login_id)
    end

    context "既に別のユーザーで利用されている場合" do
      before do
        @org = FactoryGirl.create(:organization)
        @subscriber_information = FactoryGirl.create(:subscriber_information, organization: @org)
        @user = FactoryGirl.create(:user, organization: @org)
      end
      it "使えないこと" do
        # 団体関係なく使えない
        RegistrationForm.new(login_id: @user.login_id).should have(1).errors_on(:login_id)
      end
    end
    context "既に別のユーザーで仮登録利用されている場合" do
     before do
        @org = FactoryGirl.create(:organization)
        @subscriber_information = FactoryGirl.create(:subscriber_information, organization: @org)
        @prov_user = FactoryGirl.create(:provisional_user, organization: @org)
     end
     it "使えること" do
       # 団体関係なく使えない
       # 本登録を先に行った方が勝ち
       # メールアドレスが間違っている場合も考えられるので
       RegistrationForm.new(login_id: @prov_user.login_id).should have(0).errors_on(:login_id)
     end
    end
  end
  context "password" do
    it "確認と一致していること" do
      RegistrationForm.new(password: "password", password_confirmation: "password").should have(0).errors_on(:password)
    end
    it "5文字以上255文字以下" do
      RegistrationForm.new(password: "ppp", password_confirmation: "ppp").should have(1).errors_on(:password)
      RegistrationForm.new(password: "pppp", password_confirmation: "pppp").should have(0).errors_on(:password)
      RegistrationForm.new(password: "ppppp", password_confirmation: "ppppp").should have(0).errors_on(:password)
      RegistrationForm.new(password: "p"*255, password_confirmation: "p"*255).should have(0).errors_on(:password)
      RegistrationForm.new(password: "p"*256, password_confirmation: "p"*256).should have(1).errors_on(:password)
    end
  end
  context "nickname" do
    it "1文字以上255文字以下" do
      RegistrationForm.new(nickname: "").should have(2).errors_on(:nickname)
      RegistrationForm.new(nickname: "p").should have(0).errors_on(:nickname)
      RegistrationForm.new(nickname: "ppppp").should have(0).errors_on(:nickname)
      RegistrationForm.new(nickname: "p"*255).should have(0).errors_on(:nickname)
      RegistrationForm.new(nickname: "p"*256).should have(1).errors_on(:nickname)
    end
  end
  context "email" do
    it "確認と一致していること" do
      RegistrationForm.new(email: "takaaki.muta@gmail.com", email_confirmation: "takaaki.muta@gmail.com").should have(0).errors_on(:email)
    end
    it "emailフォーマットであること" do
      RegistrationForm.new(email: "takaaki.muta@@gmail.com", email_confirmation: "takaaki.muta@@gmail.com").should have(1).errors_on(:email)
      RegistrationForm.new(email: "taka@aki.muta@gmail.com", email_confirmation: "taka@aki.muta@gmail.com").should have(1).errors_on(:email)
      # TODO: 追加する
    end
  end

end
