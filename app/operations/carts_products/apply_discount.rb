# frozen_string_literal: true

module CartsProducts
  class ApplyDiscount
    prepend BaseOperation

    option :carts_products,
           type: Types.Instance(CartsProduct.const_get(:ActiveRecord_Relation))

    def call
      return if carts_products.empty?

      set_product_and_quantity
      calculate_discount
      update_price!
    end

    private

    def set_product_and_quantity
      @product = @carts_products.take.product
      @quantity = @carts_products.count
    end

    def calculate_discount
      @discount = Actions::Discounts::Calculate.call(
        product: @product,
        quantity: @quantity
      ).result
    end

    def update_price!
      return unless @discount.applied?

      @carts_products.each_with_index do |cart_product, index|
        cart_product.update!(price: @discount.prices[index])
      end
    end
  end
end
