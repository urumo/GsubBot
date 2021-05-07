# frozen_string_literal: true

class CreateBots < ActiveRecord::Migration[6.1]
  def change
    create_table :bots do |t|
      t.string :alias
      t.string :token

      t.timestamps
    end
    add_index :bots, :alias, unique: true
    add_index :bots, :token, unique: true
  end
end
