# frozen_string_literal: true

class CreateGosuModels < ActiveRecord::Migration[6.1]
  def change
    create_table :gosu_models do |t|
      t.text :reply

      t.timestamps
    end
  end
end
