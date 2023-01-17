# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CartsController, type: :request do
  let(:headers) do
    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end

  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }
  let(:response_body_data) { response_body.fetch(:data) }
  let(:response_body_data_attributes) { response_body_data.fetch(:attributes) }
  let(:response_body_carts_products) { response_body_data_attributes.fetch(:carts_products) }

  let!(:cart_id) { create(:cart).id }
  let!(:string_cart_id) { cart_id.to_s }

  let(:zero_amount) { Money.new(0.00) }
  let(:cart_json_type) { 'cart' }
  let(:carts_product_json_type) { 'carts_product' }
  let(:product_json_type) { 'product' }

  let(:green_tea_product_name) { 'Green Tea' }
  let(:green_tea_product_code) { 'GR1' }
  let(:green_tea_product_price) { Money.new(3.11) }

  let!(:green_tea_product) do
    create(
      :product,
      name: green_tea_product_name,
      code: green_tea_product_code,
      price: green_tea_product_price
    )
  end

  let(:green_tea_product_id) { green_tea_product.id }
  let(:string_green_tea_product_id) { green_tea_product_id.to_s }

  let(:strawberries_product_name) { 'Strawberries' }
  let(:strawberries_product_code) { 'SR1' }
  let(:strawberries_product_price) { Money.new(5.00) }

  let!(:strawberries_product) do
    create(
      :product,
      name: strawberries_product_name,
      code: strawberries_product_code,
      price: strawberries_product_price
    )
  end

  let(:strawberries_product_id) { strawberries_product.id }
  let(:string_strawberries_product_id) { strawberries_product_id.to_s }

  let(:coffee_product_name) { 'Coffee' }
  let(:coffee_product_code) { 'CF1' }
  let(:coffee_product_price) { Money.new(11.23) }

  let!(:coffee_product) do
    create(
      :product,
      name: coffee_product_name,
      code: coffee_product_code,
      price: coffee_product_price
    )
  end

  let(:coffee_product_id) { coffee_product.id }
  let(:string_coffee_product_id) { coffee_product_id.to_s }

  let(:green_tea_action_bonus) do
    create(:action_bonus, bonus_quantity: 1, min_quantity: 0)
  end

  let(:coffee_action_discount) do
    create(:action_discount, min_quantity: 3, coefficient: 0.666666666667)
  end

  let(:strawberries_action_discount) do
    create(:action_discount, min_quantity: 3, coefficient: 0.9)
  end

  def carts_product_hash(price, product_id, bonus: false)
    a_hash_including(
      :id,
      type: carts_product_json_type,
      attributes: {
        price: price_with_currency(price),
        bonus: bonus
      },
      relationships: {
        product: {
          data: {
            id: product_id,
            type: product_json_type
          }
        }
      }
    )
  end

  shared_examples :cart_response_attributes do
    it 'contains a cart attributes' do
      expect(response_body_data.fetch(:id)).to eq(string_cart_id)
      expect(response_body_data.fetch(:type)).to eq(cart_json_type)
    end
  end

  def price_with_currency(amount)
    Money.new(amount).as_json
  end

  describe 'POST /api/carts' do
    def create_cart_request
      post '/api/carts', headers: headers, xhr: true
    end

    before { create_cart_request }

    it 'returns status created ' do
      expect(response.code).to eq('201')
    end

    it 'invokes proper operation' do
      expect(Carts::Create).to receive(:call).and_call_original
      create_cart_request
    end

    it 'returns an empty cart' do
      expect(response_body_data_attributes.fetch(:total)).to eq(price_with_currency(zero_amount))
      expect(response_body_carts_products.fetch(:data)).to eq([])
    end
  end

  describe 'GET /api/carts/{id}' do
    def get_cart_request
      get "/api/carts/#{cart_id}", headers: headers, xhr: true
    end

    before { get_cart_request }

    it 'returns status created ' do
      expect(response.code).to eq('200')
    end

    it 'invokes proper operation' do
      expect(Carts::Show).to receive(:call).with(cart_id: string_cart_id).and_call_original
      get_cart_request
    end

    include_examples :cart_response_attributes
  end

  describe 'POST /api/carts/add_product' do
    before do
      green_tea_product.actions = [green_tea_action_bonus]
      strawberries_product.actions = [strawberries_action_discount]
      coffee_product.actions = [coffee_action_discount]
    end

    let(:params_for_green_tea) do
      {
        data: {
          cart_id: cart_id,
          product_id: green_tea_product_id,
          quantity: green_tea_quantity
        }
      }
    end

    let(:params_for_strawberries) do
      {
        data: {
          cart_id: cart_id,
          product_id: strawberries_product_id,
          quantity: strawberries_quantity
        }
      }
    end

    let(:params_for_coffee) do
      {
        data: {
          cart_id: cart_id,
          product_id: coffee_product_id,
          quantity: coffee_quantity
        }
      }
    end

    let(:green_tea_product_response_attributes) do
      {
        id: string_green_tea_product_id,
        type: product_json_type,
        attributes: {
          name: green_tea_product_name,
          code: green_tea_product_code,
          price: price_with_currency(green_tea_product_price)
        }
      }
    end

    let(:strawberries_product_response_attributes) do
      {
        id: string_strawberries_product_id,
        type: product_json_type,
        attributes: {
          name: strawberries_product_name,
          code: strawberries_product_code,
          price: price_with_currency(strawberries_product_price)
        }
      }
    end

    let(:coffee_product_response_attributes) do
      {
        id: string_coffee_product_id,
        type: product_json_type,
        attributes: {
          name: coffee_product_name,
          code: coffee_product_code,
          price: price_with_currency(coffee_product_price)
        }
      }
    end

    def add_product_to_cart_request(params)
      post '/api/carts/add_product',
           headers: headers,
           params: params.to_json,
           xhr: true
    end

    shared_examples :carts_products_response_attributes do
      it 'returns an expected carts_products attributes' do
        expect(response_body_data_attributes.fetch(:total)).to eq(price_with_currency(expected_total_price))
        expect(response_body_carts_products.fetch(:data)).to match(expected_carts_products[:data])
        expect(response_body_carts_products.fetch(:included)).to match(expected_carts_products[:included])
      end
    end

    context 'green tea 1 + bonus' do
      let(:green_tea_quantity) { 1 }

      before do
        add_product_to_cart_request(params_for_green_tea)
      end

      let(:expected_carts_products) do
        {
          data: [
            carts_product_hash(
              green_tea_product_price,
              string_green_tea_product_id
            ),

            carts_product_hash(
              zero_amount,
              string_green_tea_product_id,
              bonus: true
            )
          ],
          included: [green_tea_product_response_attributes]
        }
      end

      let(:expected_total_price) { green_tea_product_price }

      it 'returns status created ' do
        expect(response.code).to eq('201')
      end

      it 'invokes proper operation' do
        expect(Carts::AddProduct).to receive(:call).with(params_for_green_tea[:data]).and_call_original
        add_product_to_cart_request(params_for_green_tea)
      end

      include_examples :cart_response_attributes
      include_examples :carts_products_response_attributes
    end

    context 'green tea + strawberries + 3 coffee' do
      let(:green_tea_quantity) { 1 }
      let(:strawberries_quantity) { 1 }
      let(:coffee_quantity) { 3 }

      before do
        add_product_to_cart_request(params_for_green_tea)
        add_product_to_cart_request(params_for_strawberries)
        add_product_to_cart_request(params_for_coffee)
      end

      let(:expected_carts_products) do
        {
          data: [
            carts_product_hash(green_tea_product_price, string_green_tea_product_id),
            carts_product_hash(zero_amount, string_green_tea_product_id, bonus: true),
            carts_product_hash(strawberries_product_price, string_strawberries_product_id),
            carts_product_hash('7.49', string_coffee_product_id),
            carts_product_hash('7.49', string_coffee_product_id),
            carts_product_hash('7.48', string_coffee_product_id)
          ],
          included: [
            green_tea_product_response_attributes,
            strawberries_product_response_attributes,
            coffee_product_response_attributes
          ]
        }
      end

      let(:expected_total_price) { '30.57' }

      include_examples :cart_response_attributes
      include_examples :carts_products_response_attributes
    end

    context '3 strawberries + 1 green tea' do
      let(:green_tea_quantity) { 1 }
      let(:strawberries_quantity) { 1 }

      before do
        add_product_to_cart_request(params_for_green_tea)
        add_product_to_cart_request(params_for_strawberries)
        add_product_to_cart_request(params_for_strawberries)
        add_product_to_cart_request(params_for_strawberries)
      end

      let(:expected_carts_products) do
        strawberries_final_price = '4.50'
        {
          data: [
            carts_product_hash(
              green_tea_product_price,
              string_green_tea_product_id
            ),

            carts_product_hash(
              zero_amount,
              string_green_tea_product_id,
              bonus: true
            ),

            carts_product_hash(
              strawberries_final_price,
              string_strawberries_product_id
            ),

            carts_product_hash(
              strawberries_final_price,
              string_strawberries_product_id
            ),

            carts_product_hash(
              strawberries_final_price,
              string_strawberries_product_id
            )
          ],
          included: [
            green_tea_product_response_attributes,
            strawberries_product_response_attributes
          ]
        }
      end

      let(:expected_total_price) { '16.61' }

      include_examples :cart_response_attributes
      include_examples :carts_products_response_attributes
    end
  end
end
