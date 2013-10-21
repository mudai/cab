require "spec_helper"

# 実装前に仕様を書き出し、テストに落としていく
describe "ログイン" do
  context "未ログイン" do
    xit "ログイン出きること"
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
