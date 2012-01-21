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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120121031636) do

  create_table "attachments", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "conversation_users", :force => true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "conversations", :force => true do |t|
    t.string   "uid"
    t.boolean  "read",        :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "user_id"
    t.datetime "received_at"
  end

  create_table "messages", :force => true do |t|
    t.text     "subject"
    t.text     "body"
    t.datetime "sent_at"
    t.integer  "conversation_id"
    t.integer  "from_user_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "starred",         :default => false
    t.integer  "user_id"
    t.string   "uid"
    t.boolean  "activity"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "uid"
    t.string   "handle"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "name"
    t.string   "avatar_url"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "google_token"
    t.string   "access_token"
  end

end
