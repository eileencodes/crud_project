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

ActiveRecord::Schema.define(version: 20140201213034) do

  create_table "contacts", force: true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "phone"
    t.string  "email"
    t.string  "address_1"
    t.string  "address_2"
    t.string  "state"
    t.string  "postal_code"
    t.string  "country"
    t.string  "company"
    t.string  "company_phone"
    t.string  "company_address_1"
    t.string  "company_address_2"
    t.string  "company_city"
    t.string  "company_state"
    t.string  "company_postal_code"
    t.string  "company_country"
    t.date    "birthday"
    t.string  "suffix"
    t.string  "prefix"
    t.integer "user_id"
    t.string  "city"
    t.string  "twitter_account_link"
    t.string  "facebook_account_link"
    t.string  "linkedin_account_link"
    t.string  "gplus_account_link"
    t.string  "github_account_link"
  end

  create_table "users", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.string "password_digest"
  end

end
