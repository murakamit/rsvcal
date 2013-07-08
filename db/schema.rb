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

ActiveRecord::Schema.define(version: 20130707093408) do

  create_table "groups", force: true do |t|
    t.string   "name",         limit: 50,                                  null: false
    t.string   "memo",         limit: 250, default: "",                    null: false
    t.datetime "removed_at",               default: '1900-01-01 00:00:00', null: false
    t.integer  "lock_version",             default: 0,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "group_id",                                                 null: false
    t.string   "name",         limit: 50,                                  null: false
    t.string   "memo",         limit: 250, default: "",                    null: false
    t.datetime "removed_at",               default: '1900-01-01 00:00:00', null: false
    t.integer  "lock_version",             default: 0,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weeklies", force: true do |t|
    t.integer  "item_id",                                                  null: false
    t.string   "user",         limit: 50,                                  null: false
    t.date     "date_begin",                                               null: false
    t.date     "date_end",                                                 null: false
    t.integer  "begin_h",                                                  null: false
    t.integer  "begin_m",                                                  null: false
    t.integer  "end_h",                                                    null: false
    t.integer  "end_m",                                                    null: false
    t.string   "icon",         limit: 50,  default: "&#9834;",             null: false
    t.string   "memo",         limit: 250, default: "",                    null: false
    t.datetime "removed_at",               default: '1900-01-01 00:00:00', null: false
    t.integer  "lock_version",             default: 0,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
