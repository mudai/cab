# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscriber_information do
    family_name "牟田"
    first_name "孝明"
    family_name_kana "ムタ"
    first_name_kana "タカアキ"
    code "muta"
    number "takaaki"
    birthday Date.new(1984,8,17)
  end
end
