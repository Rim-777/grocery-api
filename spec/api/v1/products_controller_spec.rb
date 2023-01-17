# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  let(:headers) do
    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end

  let(:response_body) { JSON.parse(response.body, symbolize_names: true) }
  let(:response_body_data) { response_body.fetch(:data) }

  let(:product_json_type) { 'product' }

  let(:green_tea_product_name) { 'Green Tea' }
  let(:green_tea_product_code) { 'GR1' }
  let(:green_tea_product_price) { Money.new(3.11) }

  let!(:green_tea_product_id) do
    create(
      :product,
      name: green_tea_product_name,
      code: green_tea_product_code,
      price: green_tea_product_price
    ).id.to_s
  end

  let(:strawberries_product_name) { 'Strawberries' }
  let(:strawberries_product_code) { 'SR1' }
  let(:strawberries_product_price) { Money.new(5.00) }

  let!(:strawberries_product_id) do
    create(
      :product,
      name: strawberries_product_name,
      code: strawberries_product_code,
      price: strawberries_product_price
    ).id.to_s
  end

  let(:coffee_product_name) { 'Coffee' }
  let(:coffee_product_code) { 'CF1' }
  let(:coffee_product_price) { Money.new(11.23) }

  let!(:coffee_product_id) do
    create(
      :product,
      name: coffee_product_name,
      code: coffee_product_code,
      price: coffee_product_price
    ).id.to_s
  end

  describe 'GET /api/products' do
    def products_request
      get '/api/products', headers: headers, xhr: true
    end

    before { products_request }

    let(:expected_response_body) do
      {
        data: [
          {
            attributes: {
              code: green_tea_product_code,
              name: green_tea_product_name,
              price: green_tea_product_price.as_json
            },
            id: green_tea_product_id,
            type: product_json_type
          },
          {
            attributes: {
              code: strawberries_product_code,
              name: strawberries_product_name,
              price: strawberries_product_price.as_json
            },
            id: strawberries_product_id,
            type: product_json_type
          },
          {
            attributes: {
              code: coffee_product_code,
              name: coffee_product_name,
              price: coffee_product_price.as_json
            },
            id: coffee_product_id,
            type: product_json_type
          }
        ],
        links: {
          first: '/api/products?page=1',
          last: '/api/products?page=1'
        }
      }
    end

    it 'returns status created ' do
      expect(response.code).to eq('200')
    end

    it 'returns an expected response body ' do
      expect(response_body).to eq(expected_response_body)
    end

    it 'invokes proper operation' do
      expect(Products::Index).to receive(:call).and_call_original
      products_request
    end
  end
end
