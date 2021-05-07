# frozen_string_literal: true

class AddAdminToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :black_listed, :boolean, default: false
    add_index :users, :tg_id, unique: true
  end
end
