# frozen_string_literal: true

class ChangeIndicesOnUser < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, name: 'index_users_on_tg_id'
    add_index :users, %i[tg_id chat_id], unique: true
  end
end
