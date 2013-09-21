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

ActiveRecord::Schema.define(version: 20130921210937) do

  create_table "builds", force: true do |t|
    t.integer  "project_id"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.boolean  "successful"
    t.text     "output"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sha"
  end

  create_table "post_build_actions", force: true do |t|
    t.string   "type"
    t.integer  "project_id"
    t.integer  "trigger_on_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "trigger_on_branch"
    t.string   "target_repo_uri"
    t.string   "target_branch"
  end

  create_table "projects", force: true do |t|
    t.string   "repo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
