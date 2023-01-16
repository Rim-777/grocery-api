# frozen_string_literal: true

module CartsProducts
  class CreateBonusItems
    prepend BaseOperation

    option :carts_products,
           type: Types.Instance(
             CartsProduct
               .const_get(
                 :ActiveRecord_Relation
               )
           )

    def call
      set_cart_product_quantity
      calculate_bonus
      create_bonus_items!
    end

    private

    def set_cart_product_quantity
      carts_product = @carts_products.take
      @cart = carts_product.cart
      @product = carts_product.product
      @quantity = @carts_products.count
    end

    def calculate_bonus
      @bonus = Actions::Bonuses::Calculate.call(
        product: @product,
        quantity: @quantity
      ).result
    end

    def create_bonus_items!
      return unless @bonus.applied?

      CartsProducts::CreateCollection.call(
        quantity: @bonus.quantity,
        attributes: bonus_item_attributes
      )
    end

    def bonus_item_attributes
      {
        product_id: @product.id,
        cart_id: @cart.id,
        price: @bonus.price,
        bonus: true
      }
    end
  end
end
