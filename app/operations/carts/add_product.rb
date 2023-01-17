# frozen_string_literal: true

module Carts
  class AddProduct
    prepend BaseOperation

    option :cart_id, type: Types::Strict::Integer
    option :product_id, type: Types::Strict::Integer
    option :quantity, type: Types::Strict::Integer

    attr_reader :cart

    def call
      set_cart!
      set_product!
      ActiveRecord::Base.transaction do
        remove_stale_bonus
        add_cart_products
        apply_discount
        add_bonus
      end
    end

    private

    def set_cart!
      @cart = Show.call(cart_id: @cart_id).result
    end

    def set_product!
      @product = Product.find(@product_id)
    end

    def remove_stale_bonus
      CartsProducts::DeleteBonusItems.call(cart_id: @cart_id, product_id: @product_id)
    end

    def add_cart_products
      CartsProducts::CreateCollection.call(
        quantity: @quantity,
        attributes: attributes
      )
    end

    def apply_discount
      CartsProducts::ApplyDiscount.call(carts_products: carts_products)
    end

    def add_bonus
      CartsProducts::CreateBonusItems.call(carts_products: carts_products)
    end

    def carts_products
      CartsProducts::FindCollection.call(
        attributes: {
          cart_id: @cart_id,
          product_id: @product_id
        }
      ).result
    end

    def attributes
      {
        cart_id: @cart_id,
        product_id: @product_id,
        price: @product.price
      }
    end
  end
end
