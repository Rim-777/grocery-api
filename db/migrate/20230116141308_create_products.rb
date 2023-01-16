# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :name, null: false
      t.decimal :price, precision: 21, scale: 12, null: false
      t.string :currency, limit: 3, null: false
      t.timestamps
    end
  end
end
