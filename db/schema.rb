# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131031111253) do

  create_table "login_histories", force: true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "ip_address"
    t.string   "user_agent"
    t.datetime "logged_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "login_id_histories", force: true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "before_login_id"
    t.datetime "changed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "login_id_histories", ["organization_id", "user_id"], name: "index_login_id_histories_on_organization_id_and_user_id"

  create_table "onetime_tokens", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "host"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "password_histories", force: true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "before_password_digest"
    t.datetime "changed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "password_histories", ["organization_id", "user_id"], name: "index_password_histories_on_organization_id_and_user_id"

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id"

  create_table "subscriber_informations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "organization_id"
    t.string   "login_id"
    t.string   "password_digest"
    t.datetime "first_logged_in_at"
    t.datetime "last_logged_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["organization_id", "login_id"], name: "index_users_on_organization_id_and_login_id"

end
