# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

org = Organization.new(name: "HCC", full_name: "HCC健康保健組合", directory: "hcc")
org.save

user = org.users.new
user.login_id = "test"
user.password = "test"
user.password_confirmation = "test"
user.save
