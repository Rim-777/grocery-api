# frozen_string_literal: true

module CartsProducts
  class CreateCollection
    prepend BaseOperation

    option :quantity, type: Types::Strict::Integer
    option :attributes, type: Types::Strict::Hash

    attr_reader :result

    def call
      collection = []

      @quantity.times do
        collection << @attributes
      end

      @result = CartsProduct.create!(collection)
    rescue ActiveRecord::RecordInvalid => e
      interrupt_with_errors!([e.message])
    end
  end
end
