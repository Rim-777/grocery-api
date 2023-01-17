# frozen_string_literal: true

module CartsProducts
  class DeleteBonusItems
    prepend BaseOperation

    option :cart_id, type: Types::Strict::Integer
    option :product_id, type: Types::Strict::Integer

    def call
      DeleteCollection.call(attributes: attributes)
    end

    private

    def attributes
      {
        cart_id: @cart_id,
        product_id: @product_id,
        bonus: true
      }
    end
  end
end
