# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provisional_user do
    status true
    family_name "牟田"
    first_name "孝明"
    family_name_kana "ムタ"
    first_name_kana "タカアキ"
    code "muta"
    number "takaaki"
    birthday Date.new(1984,8,17)
    email "takaaki.muta@gmail.com"
    login_id "login_id"
    nickname "nickname"
    password "test"
    password_confirmation "test"
  end
end
