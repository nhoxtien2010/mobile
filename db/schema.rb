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

ActiveRecord::Schema.define(version: 20150608143856) do

  create_table "giaodiches", force: true do |t|
    t.date     "ngay"
    t.integer  "sanpham_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "giaodiches", ["sanpham_id"], name: "index_giaodiches_on_sanpham_id"

  create_table "hangsanxuats", force: true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "ten"
    t.string   "hinhanh"
    t.string   "diachi"
  end

  create_table "hedieuhanhs", force: true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "ten"
  end

  create_table "sanphams", force: true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "ten"
    t.integer  "gia"
    t.integer  "hedieuhanh_id"
    t.string   "dophangiaimanhinh"
    t.float    "camera"
    t.integer  "bonhotrong"
    t.integer  "thenhongoai"
    t.integer  "ram"
    t.integer  "pin"
    t.string   "cpu"
    t.integer  "hangsanxuat_id"
    t.string   "hinhanh"
  end

end
