# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

org = Organization.new(name: "HCC", full_name: "HCC健康保健組合", host: "localhost")
org.save

org.subscriber_informations.create(
  user_id: nil, family_name: "牟田", first_name: "孝明",
  family_name_kana: "ムタ", first_name_kana: "タカアキ",
  code: "muta", number: "takaaki", birthday: Date.new(1984,8,17)
)


user = org.users.new
user.login_id = "test"
user.password = "test"
user.password_confirmation = "test"
user.save

org = Organization.new(name: "HCC2", full_name: "HCC2健康保健組合", host: "localhost2")
org.save

user = org.users.new
user.login_id = "test2"
user.password = "test2"
user.password_confirmation = "test2"
user.save
