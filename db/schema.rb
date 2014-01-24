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

ActiveRecord::Schema.define(version: 20140124203232) do

  create_table "assignments", force: true do |t|
    t.integer  "volunteer_id"
    t.integer  "geography_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["geography_id"], name: "index_assignments_on_geography_id", using: :btree
  add_index "assignments", ["volunteer_id"], name: "index_assignments_on_volunteer_id", using: :btree

  create_table "geographies", force: true do |t|
    t.integer  "village_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "family_id"
    t.decimal  "amount",         precision: 8, scale: 2
    t.datetime "date"
    t.string   "deposit_number"
    t.integer  "volunteer_id"
    t.string   "voucher"
    t.decimal  "debt",           precision: 8, scale: 0
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
