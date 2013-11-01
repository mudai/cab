require "spec_helper"

# 実装前に仕様を書き出し、テストに落としていく
describe "ログイン" do
  before do
    @org = FactoryGirl.create(:organization)
    @user = FactoryGirl.create(:user, organization: @org)
  end
  context "未ログイン" do
    context "存在しないホストへのアクセス" do
      context "404となる" do
        it "/" do
          visit "http://unknown.qupio.com/"
          page.status_code.should == 404
        end
        it "/login" do
          visit "http://unknown.qupio.com/login"
          page.status_code.should == 404
        end
        it "/logout" do
          visit "http://unknown.qupio.com/logout"
          page.status_code.should == 404
        end
        it "/account/edit" do
          visit "http://unknown.qupio.com/account/edit"
          page.status_code.should == 404
        end
      end
    end
    context "存在するホストへのアクセス" do
      it '/loginへリダイレクト' do
        visit 'http://www.qupio.com/'
        page.status_code.should == 200
        current_path.should == '/login'
      end
      it '存在しないdirは404' do
        visit 'http://www.qupio.com/aaaaa'
        page.status_code.should == 404
      end
      it "ログイン出きること" do
        visit 'http://www.qupio.com/login'
        fill_in 'authentication_form_login_id', with: 'test'
        fill_in 'authentication_form_password', with: 'test'
        click_button 'ログイン'
        current_path.should == '/'
        page.should have_content("Logged in!")
      end
      it "ログインIDかパスワードを間違えるとログインできないこと" do
        visit 'http://www.qupio.com/login'
        fill_in 'authentication_form_login_id', with: 'hoge'
        fill_in 'authentication_form_password', with: 'test'
        click_button 'ログイン'
        current_path.should == '/login_process'
        page.should have_content("Login_id or Password is invalid")
      end

      it "ログインしたらログイン履歴テーブルにログイン履歴がinsertされること" do
        -> {
          visit 'http://www.qupio.com/login'
          fill_in 'authentication_form_login_id', with: 'test'
          fill_in 'authentication_form_password', with: 'test'
          click_button 'ログイン'
          current_path.should == '/'
        }.should change(LoginHistory, :count).by(1)
      end

      it "URL直指定の場合はログイン画面を後に指定のURLに遷移すること" do
        visit 'http://www.qupio.com/account/edit'
        current_path.should == '/login'
        fill_in 'authentication_form_login_id', with: 'test'
        fill_in 'authentication_form_password', with: 'test'
        click_button 'ログイン'
        current_path.should == '/account/edit'
        page.should have_content("Logged in!")
      end
    end
    context "ログイン済み" do
      before do
        visit 'http://www.qupio.com/login'
        fill_in 'authentication_form_login_id', with: 'test'
        fill_in 'authentication_form_password', with: 'test'
        click_button 'ログイン'
        current_path.should == '/'
        page.should have_content("Logged in!")
      end
      it "ログインページを開いたらログアウト状態となること" do
        visit 'http://www.qupio.com/login'
        current_path.should == '/login'
        visit 'http://www.qupio.com/'
        current_path.should == '/login'
      end
    end
  end
end

describe "ログアウト" do
  before do
    @org = FactoryGirl.create(:organization)
    @user = FactoryGirl.create(:user, organization: @org)
  end
  context "既にログインしている場合" do
    before do
      visit 'http://www.qupio.com/login'
      fill_in 'authentication_form_login_id', with: 'test'
      fill_in 'authentication_form_password', with: 'test'
      click_button 'ログイン'
      current_path.should == '/'
      page.should have_content("Logged in!")
    end
    it "ログアウトできること" do
      visit 'http://www.qupio.com/logout'
      page.should have_content("Logout Success")
    end
  end
  context "ログインしていない場合" do
    it "ログアウト処理を行ってもエラーとならないこと" do
      visit 'http://www.qupio.com/logout'
      page.should have_content("Logout Success")
    end
  end
end
