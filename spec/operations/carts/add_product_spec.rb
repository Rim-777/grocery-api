# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::AddProduct do
  def operation_call(payload)
    described_class.call(payload)
  end

  let!(:cart) { create(:cart) }
  let!(:cart_id) { cart.id }

  let(:payload) { { cart_id: cart_id } }

  describe '#call' do
    let(:green_tea_price) { Money.new(3.11) }

    let!(:green_tea) do
      create(:product, code: 'GR1', name: 'Green Tea', price: green_tea_price)
    end

    let(:green_tea_id) { green_tea.id }

    let!(:coffee) do
      create(:product, code: 'CF1', name: 'Coffee', price: Money.new(11.23))
    end

    let(:coffee_id) { coffee.id }

    let!(:strawberries) do
      create(:product, code: 'SR1', name: 'Strawberries', price: Money.new(5.0))
    end

    let(:strawberries_id) { strawberries.id }

    let(:green_tea_action_bonus) do
      create(:action_bonus, bonus_quantity: 1, min_quantity: 0)
    end

    let(:coffee_action_discount) do
      create(:action_discount, min_quantity: 3, coefficient: 0.66666666667)
    end

    let(:strawberries_action_discount) do
      create(:action_discount, min_quantity: 3, coefficient: 0.9)
    end

    before do
      green_tea.actions = [green_tea_action_bonus]
      coffee.actions = [coffee_action_discount]
      strawberries.actions = [strawberries_action_discount]
    end

    let(:cart_products) do
      cart.reload.carts_products
    end

    let(:green_tea_cart_products) do
      cart_products.where(product: green_tea)
    end

    let(:green_tea_bonus_cart_products) do
      green_tea_cart_products.where(bonus: true)
    end

    let(:green_tea_base_cart_products) do
      green_tea_cart_products.where(bonus: false)
    end

    let(:coffee_carts_products) do
      cart_products.where(product: coffee)
    end

    let(:strawberries_cart_products) do
      cart_products.where(product: strawberries)
    end

    let(:green_tea_payload) do
      payload[:product_id] = green_tea_id
      payload[:quantity] = 2
      payload
    end

    let(:coffee_payload) do
      payload[:product_id] = coffee_id
      payload[:quantity] = 3
      payload
    end

    let(:strawberries_payload) do
      payload[:product_id] = strawberries_id
      payload[:quantity] = 3
      payload
    end

    def add_green_tea
      operation_call(green_tea_payload)
    end

    def add_strawberries
      operation_call(strawberries_payload)
    end

    def add_coffee
      operation_call(coffee_payload)
    end

    def add_all_products
      add_green_tea
      add_coffee
      add_strawberries
    end

    context 'success' do
      context 'actions applied' do
        context 'quantity' do
          it 'adds an expected number of records' do
            expect { add_green_tea }.to change(CartsProduct, :count).from(0).to(4)
          end

          it 'adds an expected number of bonus records' do
            expect { add_green_tea }.to change(green_tea_bonus_cart_products, :count).from(0).to(2)
          end

          it 'adds an expected number of target records' do
            expect { add_green_tea }.to change(green_tea_base_cart_products, :count).from(0).to(2)
          end

          it 'adds an expected number of coffee' do
            expect { add_coffee }.to change(CartsProduct, :count).from(0).to(3)
          end

          it 'adds and relates an expected number of coffee' do
            expect { add_coffee }.to change(coffee_carts_products, :count).from(0).to(3)
          end

          it 'adds an expected number of strawberries' do
            expect { add_strawberries }.to change(CartsProduct, :count).from(0).to(3)
          end

          it 'adds an relates expected number of strawberries' do
            expect { add_strawberries }.to change(strawberries_cart_products, :count).from(0).to(3)
          end

          it 'adds an expected number of all products' do
            add_all_products

            expect(cart_products.count).to eq(10)
          end
        end

        context 'price' do
          before { add_all_products }

          it 'reduces coffee price' do
            coffee_carts_products.first(2).each do |coffee_cards_product|
              expect(coffee_cards_product.price).to eq(Money.new(7.49))
            end

            expect(coffee_carts_products.last.price).to eq(Money.new(7.48))
          end

          it 'reduces strawberries price' do
            strawberries_cart_products.each do |strawberries_cards_product|
              expect(strawberries_cards_product.price).to eq(Money.new(4.50))
            end
          end

          it 'reduces green_tea price' do
            green_tea_base_cart_products.each do |green_tea_cards_product|
              expect(green_tea_cards_product.price).to eq(green_tea_price)
            end
          end

          it 'reduces green_tea bonus price' do
            green_tea_bonus_cart_products.each do |green_tea_cards_product|
              expect(green_tea_cards_product.price.to_f).to be_zero
            end
          end
        end
      end

      context 'actions not applied' do
        before { green_tea.actions = [] }

        let(:coffee_payload) do
          payload[:product_id] = coffee_id
          payload[:quantity] = 2
          payload
        end

        let(:strawberries_payload) do
          payload[:product_id] = strawberries_id
          payload[:quantity] = 2
          payload
        end

        context 'quantity' do
          it 'adds an expected number of records' do
            expect { add_green_tea }.to change(CartsProduct, :count).from(0).to(2)
          end

          it 'does not add bonus records' do
            expect { add_green_tea }.not_to change(green_tea_bonus_cart_products, :count)
          end

          it 'adds an expected number of target records' do
            expect {  add_green_tea }.to change(green_tea_base_cart_products.reload, :count).from(0).to(2)
          end

          it 'adds an expected number of coffee' do
            expect { add_coffee }.to change(CartsProduct, :count).from(0).to(2)
          end

          it 'adds and relates an expected number of coffee' do
            expect { add_coffee }.to change(coffee_carts_products, :count).from(0).to(2)
          end

          it 'adds an expected number of strawberries' do
            expect { add_strawberries }.to change(CartsProduct, :count).from(0).to(2)
          end

          it 'adds and relates an expected number of strawberries' do
            expect { add_strawberries }.to change(strawberries_cart_products, :count).from(0).to(2)
          end

          it 'adds an expected number of all products' do
            add_all_products

            expect(cart_products.count).to eq(6)
          end
        end

        context 'price' do
          before { add_all_products }

          it 'does not change coffee price' do
            coffee_carts_products.each do |coffee_cards_product|
              expect(coffee_cards_product.price).to eq(coffee.price)
            end
          end

          it 'does not change strawberries price' do
            strawberries_cart_products.each do |strawberries_cards_product|
              expect(strawberries_cards_product.price).to eq(strawberries.price)
            end
          end

          it 'does assigns green_tea target price' do
            green_tea_base_cart_products.each do |green_tea_cards_product|
              expect(green_tea_cards_product.price).to eq(green_tea_price)
            end
          end

          it 'does assigns green_tea bonus price' do
            green_tea_bonus_cart_products.each do |green_tea_cards_product|
              expect(green_tea_cards_product.price.value).to be_zero
            end
          end
        end
      end
    end

    context 'failure' do
      let(:payload) do
        {
          product_id: green_tea_id,
          cart_id: cart_id,
          quantity: 3
        }
      end

      let(:none_existing_id) { 1_234_567_890 }

      let(:expected_message) { "Couldn't find #{model} with 'id'=#{none_existing_id}" }

      shared_examples :not_found do
        it 'raises an expected error' do
          expect { add_coffee }.to raise_error(ActiveRecord::RecordNotFound, expected_message)
        end
      end

      context '#set_cart' do
        let(:model) { Cart.name }

        before do
          coffee_payload[:cart_id] = none_existing_id
        end

        include_examples :not_found
      end

      context '#set_product' do
        let(:model) { Product.name }

        before do
          coffee_payload[:product_id] = none_existing_id
        end

        include_examples :not_found
      end
    end
  end
end
