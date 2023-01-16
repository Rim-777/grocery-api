# frozen_string_literal: true

class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.string :type, null: false, index: true
      t.decimal :coefficient, precision: 12, scale: 10, null: false, default: 1
      t.integer :min_quantity, null: false
      t.integer :bonus_quantity, null: false, default: 0

      t.timestamps
    end
  end
end
