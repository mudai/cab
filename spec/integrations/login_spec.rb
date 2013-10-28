require "spec_helper"

# 実装前に仕様を書き出し、テストに落としていく
describe "ログイン" do
  before do
    @org = FactoryGirl.create(:organization)
    @user = FactoryGirl.create(:user, organization: @org)
  end
  context "未ログイン" do
    it '/は404' do
      visit '/'
      page.status_code.should == 404
    end
    it '存在しないdirは404' do
      visit '/hoge'
      page.status_code.should == 404
    end
    it '存在するdirは/loginへリダイレクトし200' do
      visit '/sample_dir'
      page.status_code.should == 200
      current_path.should == '/sample_dir/login'
    end
    it "ログイン出きること" do
      visit '/sample_dir'
      fill_in 'authentication_form_login_id', with: 'test'
      fill_in 'authentication_form_password', with: 'test'
      click_button 'ログイン'
      current_path.should == '/sample_dir'
      page.should have_content("Logged in!")
    end
    it "ログインIDかパスワードを間違えるとログインできないこと" do
      visit '/sample_dir'
      fill_in 'authentication_form_login_id', with: 'hoge'
      fill_in 'authentication_form_password', with: 'test'
      click_button 'ログイン'
      current_path.should == '/sample_dir/login_process'
      page.should have_content("Login_id or Password is invalid")
    end

    xit "ログインしたらログイン履歴テーブルにログイン履歴がinsertされること" 

    it "URL直指定の場合はログイン画面を後に指定のURLに遷移すること" do
      visit '/sample_dir/account/edit'
      current_path.should == '/sample_dir/login'
      fill_in 'authentication_form_login_id', with: 'test'
      fill_in 'authentication_form_password', with: 'test'
      click_button 'ログイン'
      current_path.should == '/sample_dir/account/edit'
      page.should have_content("Logged in!")
    end
  end
  context "ログイン済み" do
    before do
      visit '/sample_dir'
      fill_in 'authentication_form_login_id', with: 'test'
      fill_in 'authentication_form_password', with: 'test'
      click_button 'ログイン'
      current_path.should == '/sample_dir'
      page.should have_content("Logged in!")
    end
    it "ログインページを開いたらログアウト状態となること" do
      visit '/sample_dir/login'
      current_path.should == '/sample_dir/login'
      #session[:user_id].should be_nil
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
      visit '/sample_dir'
      fill_in 'authentication_form_login_id', with: 'test'
      fill_in 'authentication_form_password', with: 'test'
      click_button 'ログイン'
      current_path.should == '/sample_dir'
      page.should have_content("Logged in!")
    end
    it "ログアウトできること" do
      visit '/sample_dir/logout'
      page.should have_content("Logout Success")
    end
  end
  context "ログインしていない場合" do
    it "ログアウト処理を行ってもエラーとならないこと" do
      visit '/sample_dir/logout'
      page.should have_content("Logout Success")
    end
  end
end

describe "SSO" do
  xit "仕様を見当すること、そもそも必要ないかもしれない"
end
