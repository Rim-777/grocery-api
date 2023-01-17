require 'swagger_helper'

describe 'Shop API' do
  path '/api/carts' do
    post 'creates a cart' do
      tags 'Carts'
      consumes 'application/json'
      produces 'application/json'

      response '201', 'cart created' do
        example 'application/json', 'created cart', {
          "data": {
            "id": '7',
            "type": 'cart',
            "attributes": {
              "total": {
                "value": '0.00',
                "currency": 'EUR'
              },
              "carts_products": {
                "data": [],
                "included": []
              }
            }
          }
        }

        run_test!
      end
    end
  end

  path '/api/carts/{id}' do
    get 'returns a cart' do
      tags 'Carts'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'cart found' do
        example 'application/json', :cart, {
          "data": {
            "id": '7',
            "type": 'cart',
            "attributes": {
              "total": {
                "value": '0.00',
                "currency": 'EUR'
              },
              "carts_products": {
                "data": [],
                "included": []
              }
            }
          }
        }

        let(:id) { create(:cart).id }
        run_test!
      end

      response '404', 'cart not found' do
        example 'application/json', :error, {
          "errors": [
            {
              "detail": "Couldn't find Cart with 'id'=777"
            }
          ]
        }

        let(:id) { 777 }
        run_test!
      end
    end
  end

  path '/api/carts/add_product' do
    post 'adds product to a cart and returns a cart' do
      tags 'Carts'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: 'object',
        properties: {
          data: {
            type: 'object',
            properties: {
              cart_id: {
                type: 'integer'
              },
              product_id: {
                type: 'integer'
              },
              quantity: {
                type: 'integer'
              }
            }
          }
        }
      }

      let(:product_id) do
        create(:product, code: 'SR1', name: 'Strawberries', price: Money.new(5.00)).id
      end

      let(:cart_id) do
        create(:cart).id
      end

      let(:params) do
        {
          data: {
            cart_id: cart_id,
            product_id: product_id,
            quantity: 3
          }
        }
      end

      response '201', 'product added' do
        example 'application/json', :cart, {
          "data": {
            "id": '8',
            "type": 'cart',
            "attributes": {
              "total": {
                "value": '30.57',
                "currency": 'EUR'
              },
              "carts_products": {
                "data": [
                  {
                    "id": '21',
                    "type": 'carts_product',
                    "attributes": {
                      "price": {
                        "value": '3.11',
                        "currency": 'EUR'
                      },
                      "bonus": false
                    },
                    "relationships": {
                      "product": {
                        "data": {
                          "id": '1',
                          "type": 'product'
                        }
                      }
                    }
                  },
                  {
                    "id": '22',
                    "type": 'carts_product',
                    "attributes": {
                      "price": {
                        "value": '0.00',
                        "currency": 'EUR'
                      },
                      "bonus": true
                    },
                    "relationships": {
                      "product": {
                        "data": {
                          "id": '1',
                          "type": 'product'
                        }
                      }
                    }
                  },
                  {
                    "id": '23',
                    "type": 'carts_product',
                    "attributes": {
                      "price": {
                        "value": '5.00',
                        "currency": 'EUR'
                      },
                      "bonus": false
                    },
                    "relationships": {
                      "product": {
                        "data": {
                          "id": '2',
                          "type": 'product'
                        }
                      }
                    }
                  },
                  {
                    "id": '24',
                    "type": 'carts_product',
                    "attributes": {
                      "price": {
                        "value": '7.49',
                        "currency": 'EUR'
                      },
                      "bonus": false
                    },
                    "relationships": {
                      "product": {
                        "data": {
                          "id": '3',
                          "type": 'product'
                        }
                      }
                    }
                  },
                  {
                    "id": '25',
                    "type": 'carts_product',
                    "attributes": {
                      "price": {
                        "value": '7.49',
                        "currency": 'EUR'
                      },
                      "bonus": false
                    },
                    "relationships": {
                      "product": {
                        "data": {
                          "id": '3',
                          "type": 'product'
                        }
                      }
                    }
                  },
                  {
                    "id": '26',
                    "type": 'carts_product',
                    "attributes": {
                      "price": {
                        "value": '7.48',
                        "currency": 'EUR'
                      },
                      "bonus": false
                    },
                    "relationships": {
                      "product": {
                        "data": {
                          "id": '3',
                          "type": 'product'
                        }
                      }
                    }
                  }
                ],
                "included": [
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
                ]
              }
            }
          }
        }

        run_test!
      end

      response '404', 'record not found' do
        example 'application/json', 'cart not found', {
          "errors": [
            {
              "detail": "Couldn't find Cart with 'id'=2"
            }
          ]
        }

        example 'application/json', 'product not found', {
          "errors": [
            {
              "detail": "Couldn't find Product with 'id'=2"
            }
          ]
        }

        let(:cart_id) { 81_230_871_231_203_712_309_712_309_712_301_271_230_897_123 }

        run_test!
      end

      response '400', 'param is invalid or missing' do
        example 'application/json', :missing_key, {
          "errors": [
            {
              "detail": {
                "data": {
                  "quantity": [
                    'is missing'
                  ]
                }
              }
            }
          ]
        }
        example 'application/json', :invalid_value, {
          "errors": [
            {
              "detail": {
                "data": {
                  "product_id": [
                    'must be an integer'
                  ]
                }
              }
            }
          ]
        }

        before do
          params[:data].delete(:quantity)
        end

        run_test!
      end
    end
  end
end
