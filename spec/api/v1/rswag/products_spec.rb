require 'swagger_helper'

describe 'Shop API' do
  path '/api/products' do
    get 'returns list of available products' do
      tags 'Products'
      consumes 'application/json'

      response '200', 'list of products' do
        example 'application/json', 'product list', {
          "data": [
            {
              "id": '1',
              "type": 'product',
              "attributes": {
                "name": 'Green Tea',
                "code": 'GR1',
                "price": {
                  "value": '3.11',
                  "currency": 'EUR'
                }
              }
            },
            {
              "id": '2',
              "type": 'product',
              "attributes": {
                "name": 'Strawberries',
                "code": 'SR1',
                "price": {
                  "value": '5.00',
                  "currency": 'EUR'
                }
              }
            },
            {
              "id": '3',
              "type": 'product',
              "attributes": {
                "name": 'Coffee',
                "code": 'CF1',
                "price": {
                  "value": '11.23',
                  "currency": 'EUR'
                }
              }
            }
          ],
          "links": {
            "first": "/api/products?page=1",
            "last": "/api/products?page=1"
          }
        }

        run_test!
      end
    end
  end
end
