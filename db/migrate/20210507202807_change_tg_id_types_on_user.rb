# frozen_string_literal: true

class ChangeTgIdTypesOnUser < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :tg_id, :bigint
    change_column :users, :chat_id, :bigint
  end
end
