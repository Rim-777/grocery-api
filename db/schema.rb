# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_116_141_437) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'actions', force: :cascade do |t|
    t.string 'type', null: false
    t.decimal 'coefficient', precision: 12, scale: 10, default: '1.0', null: false
    t.integer 'min_quantity', null: false
    t.integer 'bonus_quantity', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['type'], name: 'index_actions_on_type'
  end

  create_table 'carts', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'carts_products', force: :cascade do |t|
    t.integer 'cart_id'
    t.integer 'product_id'
    t.decimal 'price', precision: 21, scale: 12, null: false
    t.string 'currency', limit: 3, null: false
    t.boolean 'bonus', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[cart_id product_id bonus], name: 'index_carts_products_on_cart_id_and_product_id_and_bonus'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'code', null: false
    t.string 'name', null: false
    t.decimal 'price', precision: 21, scale: 12, null: false
    t.string 'currency', limit: 3, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['code'], name: 'index_products_on_code', unique: true
  end

  create_table 'products_actions', force: :cascade do |t|
    t.integer 'product_id'
    t.integer 'action_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[product_id action_id], name: 'index_products_actions_on_product_id_and_action_id', unique: true
  end
end
