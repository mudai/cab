# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name 'name'
    full_name 'full_name'
    directory 'sample_dir'
  end
end
