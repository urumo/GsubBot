# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :tg_id
      t.integer :chat_id
      t.string :first_name
      t.string :last_name
      t.string :user_name

      t.timestamps
    end
  end
end
