# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    login_id 'test'
    password 'test'
    password_confirmation 'test'
    first_logged_in_at nil
    last_logged_in_at nil
  end
end
