require "spec_helper"

describe "ユーザー登録" do
  context "存在するホストへのアクセス" do
    before do
      @org = FactoryGirl.create(:organization)
      @subscriber_information = FactoryGirl.create(:subscriber_information, organization: @org)
      @user = FactoryGirl.create(:user, organization: @org)
    end
    context "仮登録フロー" do
      it "/signupが存在" do
        visit "http://www.qupio.com/signup"
        page.status_code.should == 200
      end
      it "正しい値を入力したら完了画面へ遷移" do
        visit "http://www.qupio.com/signup"
        fill_in "registration_form_code", with: "muta"
        fill_in "registration_form_number", with: "takaaki"
        fill_in "registration_form_family_name_kana", with: "ムタ"
        fill_in "registration_form_first_name_kana", with: "タカアキ"
        select "1984", from: "registration_form_birthday_1i"
        select "8", from: "registration_form_birthday_2i"
        select "17", from: "registration_form_birthday_3i"

        fill_in "registration_form_email", with: "muta.takaaki@hcc-jp.com"
        fill_in "registration_form_email_confirmation", with: "muta.takaaki@hcc-jp.com"
        click_button '仮登録'
        current_path.should == "/signup_provisional"
      end

      it "不正な値を入力したらバリデーションエラー画面となること" do # 詳しいバリデーションはformsの方でやること
        visit "http://www.qupio.com/signup"
        fill_in "registration_form_code", with: "hoge"
        fill_in "registration_form_number", with: "takaaki"
        fill_in "registration_form_family_name_kana", with: "ムタ"
        fill_in "registration_form_first_name_kana", with: "タカアキ"
        select "1984", from: "registration_form_birthday_1i"
        select "8", from: "registration_form_birthday_2i"
        select "17", from: "registration_form_birthday_3i"

        fill_in "registration_form_email", with: "muta.takaaki@hcc-jp.com"
        fill_in "registration_form_email_confirmation", with: "muta.takaaki@hcc-jp.com"
        click_button '仮登録'
        current_path.should == "/signup_process"
      end
      it "メール送信先が入力されたメールアドレスとなっていること" do
        visit "http://www.qupio.com/signup"
        fill_in "registration_form_code", with: "muta"
        fill_in "registration_form_number", with: "takaaki"
        fill_in "registration_form_family_name_kana", with: "ムタ"
        fill_in "registration_form_first_name_kana", with: "タカアキ"
        select "1984", from: "registration_form_birthday_1i"
        select "8", from: "registration_form_birthday_2i"
        select "17", from: "registration_form_birthday_3i"

        fill_in "registration_form_email", with: "muta.takaaki@hcc-jp.com"
        fill_in "registration_form_email_confirmation", with: "muta.takaaki@hcc-jp.com"
        click_button '仮登録'
        last_email.to.should include("muta.takaaki@hcc-jp.com")
      end

      xit "正しい値を入力し送信されたメールは認証用tokenが記載されていること" do
        visit "http://www.qupio.com/signup"
        fill_in "registration_form_code", with: "muta"
        fill_in "registration_form_number", with: "takaaki"
        fill_in "registration_form_family_name_kana", with: "ムタ"
        fill_in "registration_form_first_name_kana", with: "タカアキ"
        select "1984", from: "registration_form_birthday_1i"
        select "8", from: "registration_form_birthday_2i"
        select "17", from: "registration_form_birthday_3i"

        fill_in "registration_form_email", with: "muta.takaaki@hcc-jp.com"
        fill_in "registration_form_email_confirmation", with: "muta.takaaki@hcc-jp.com"
        click_button '仮登録'
        last_email.body.should include("aaaa") # tokenとなっていること
      end
      xit "別々のトークンが発行されること最新のtokenだけが有効であること"
      xit "正しい値を入力した場合は仮登録テーブルへレコードが追加されること"
    end
    context "本登録フロー" do
      xit "有効時間内で正しいtokenurlの場合は完了画面へ遷移しログイン状態となっていること"
      xit "有効時間内で正しいtokenurlの場合は完了画面へ遷移し登録完了メールが送信されること"
      xit "無効なtokenurlの場合は「既に認証済みかURLが不正かタイムアウト」と言う旨のページとなること" # render?
      xit "有効なtokenurlでタイムアウト状態であれば「既に認証済みかURLが不正かタイムアウト」と言う旨のページとなること"
      xit "/へ遷移すると既にログイン状態となっていて/loginへリダイレクトしないこと"
    end
  end
  context "存在しないホストへのアクセス" do
    xit "404となること"
  end
end
