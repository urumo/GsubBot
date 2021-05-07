# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_507_202_807) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'bots', force: :cascade do |t|
    t.string 'alias'
    t.string 'token'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['alias'], name: 'index_bots_on_alias', unique: true
    t.index ['token'], name: 'index_bots_on_token', unique: true
  end

  create_table 'gosu_models', force: :cascade do |t|
    t.text 'reply'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', force: :cascade do |t|
    t.bigint 'tg_id'
    t.bigint 'chat_id'
    t.string 'first_name'
    t.string 'last_name'
    t.string 'user_name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'admin', default: false
    t.boolean 'black_listed', default: false
    t.boolean 'super_black_list', default: false
    t.index ['tg_id'], name: 'index_users_on_tg_id', unique: true
  end
end
