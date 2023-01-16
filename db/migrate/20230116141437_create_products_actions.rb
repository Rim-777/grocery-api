# frozen_string_literal: true

class CreateProductsActions < ActiveRecord::Migration[7.0]
  def change
    create_table :products_actions do |t|
      t.integer :product_id, foreign_key: true
      t.integer :action_id, foreign_key: true

      t.index(
        %i[
          product_id
          action_id
        ], unique: true
      )

      t.timestamps
    end
  end
end
