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
        fill_in "registration_form_login_id", with: "login_id"
        fill_in "registration_form_password", with: "password"
        fill_in "registration_form_password_confirmation", with: "password"
        fill_in "registration_form_nickname", with: "nickname"
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
        fill_in "registration_form_login_id", with: "login_id"
        fill_in "registration_form_password", with: "password"
        fill_in "registration_form_password_confirmation", with: "password"
        fill_in "registration_form_nickname", with: "nickname"
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
        fill_in "registration_form_login_id", with: "login_id"
        fill_in "registration_form_password", with: "password"
        fill_in "registration_form_password_confirmation", with: "password"
        fill_in "registration_form_nickname", with: "nickname"
        click_button '仮登録'
        last_email.to.should include("muta.takaaki@hcc-jp.com")
      end

      it "正しい値を入力し送信されたメールは認証用token_urlが記載されていること" do
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
        fill_in "registration_form_login_id", with: "login_id"
        fill_in "registration_form_password", with: "password"
        fill_in "registration_form_password_confirmation", with: "password"
        fill_in "registration_form_nickname", with: "nickname"
        click_button '仮登録'
        
        last_email.body.should include("http://www.qupio.com/signup_token/#{OnetimeToken.last.token}")
      end
      it "別々のトークンが発行されること最新のtokenだけが有効であること" do
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
        fill_in "registration_form_login_id", with: "login_id"
        fill_in "registration_form_password", with: "password"
        fill_in "registration_form_password_confirmation", with: "password"
        fill_in "registration_form_nickname", with: "nickname"
        click_button '仮登録'
        token2_obj = OnetimeToken.last
        token2 = token2_obj.token
        token2_obj.status.should be_true # 発行当時はtrue

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
        fill_in "registration_form_login_id", with: "login_id"
        fill_in "registration_form_password", with: "password"
        fill_in "registration_form_password_confirmation", with: "password"
        fill_in "registration_form_nickname", with: "nickname"
        click_button '仮登録'
        token1_obj = OnetimeToken.last
        token1 = token1_obj.token

        token2.should_not equal token1 # tokenが違っていること
        token2_obj.reload.status.should be_false # 古い方は無効化されていること
        token1_obj.reload.status.should be_true # 新しい方は有効化されていること
      end
      it "正しい値を入力した場合は仮登録テーブルへレコードが追加されること" do
        expect {
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
          fill_in "registration_form_login_id", with: "login_id"
          fill_in "registration_form_password", with: "password"
          fill_in "registration_form_password_confirmation", with: "password"
          fill_in "registration_form_nickname", with: "nickname"
          click_button '仮登録'
        }.to change( ProvisionalUser, :count ).from(0).to(1)
      end
    end
    context "本登録フロー" do
      before do
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
        fill_in "registration_form_login_id", with: "login_id"
        fill_in "registration_form_password", with: "password"
        fill_in "registration_form_password_confirmation", with: "password"
        fill_in "registration_form_nickname", with: "nickname"
        click_button '仮登録'
      end
      context "存在するtokenurl" do
        context "有効時間内" do
          it "本登録完了画面へ遷移すること" do
            visit "http://www.qupio.com/signup_token/#{OnetimeToken.last.token}"
            current_path.should == "/signup_confirmed"
          end
          it "本登録完了画面へ遷移した場合、userテーブルへ正しい情報が書き込まれること" do
            visit "http://www.qupio.com/signup_token/#{OnetimeToken.last.token}"
            user = User.last
            user.login_id.should == "login_id"
            user.profile.nickname.should == "nickname"
          end
          xit "本登録完了画面へ遷移した場合、登録勘R尿メールが送信されること" do
          end
          it "本登録完了画面を閉じて通常どおりのloginができること" do
            visit "http://www.qupio.com/signup_token/#{OnetimeToken.last.token}"

            visit 'http://www.qupio.com/login'
            fill_in 'authentication_form_login_id', with: 'login_id'
            fill_in 'authentication_form_password', with: 'password'
            click_button 'ログイン'
            current_path.should == '/'
            page.should have_content("Logged in!")
          end
        end
        context "有効時間外" do
          before do
            Timecop.travel(Time.now + 30.days)
          end
          after do
            Timecop.return
          end
          it "tokenが無効な旨を表示すること" do
            visit "http://www.qupio.com/signup_token/#{OnetimeToken.last.token}"
            current_path.should == "/signup_token_error"
          end
        end
      end
      xit "既に承認済みのURLの場合token errorのページへ遷移すること"
      xit "/へ遷移すると既にログイン状態となっていて/loginへリダイレクトしないこと"
    end
  end
  context "存在しないホストへのアクセス" do
    xit "404となること"
  end
end
