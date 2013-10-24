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
    it '存在するdirは200' do
      visit '/sample_dir'
      page.status_code.should == 200
    end
    it "ログイン出きること" do
      visit '/sample_dir'
      fill_in 'authentication_form_login_id', with: 'test'
      fill_in 'authentication_form_password', with: 'test'
      click_link 'commit'

    end
    xit "ログインIDかパスワードを間違えるとログインできないこと"
    xit "ログインしたらログイン履歴テーブルにログイン履歴がinsertされること"
    xit "URL直指定の場合はログイン画面を後に指定のURLに遷移すること"
  end
  context "ログイン済み" do
    xit "ログインページを開いたらログイン後のTOPページを開くこと"
  end
end

describe "ログアウト" do
  xit "既にログインしている場合ログアウトできること"
  xit "既にログアウトしている場合、ログアウトしてもエラーとならないこと"
  xit "ログアウト"
end

describe "SSO" do
  xit "仕様を見当すること、そもそも必要ないかもしれない"
end
