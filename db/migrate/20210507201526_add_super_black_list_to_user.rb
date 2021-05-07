# frozen_string_literal: true

class AddSuperBlackListToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :super_black_list, :boolean, default: false
  end
end
