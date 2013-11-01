# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name 'name'
    full_name 'full_name'
    host 'www.qupio.com'
  end
end
