# frozen_string_literal: true

class CreateCartsProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts_products do |t|
      t.integer :cart_id, foreign_key: true
      t.integer :product_id, foreign_key: true
      t.decimal :price, precision: 21, scale: 12, null: false
      t.string :currency, limit: 3, null: false
      t.boolean :bonus, default: false, null: false

      t.index(
        %i[
          cart_id
          product_id
          bonus
        ]
      )

      t.timestamps
    end
  end
end
