# frozen_string_literal: true

module CartsProducts
  class FindCollection
    prepend BaseOperation

    option :attributes, type: Types::Strict::Hash

    attr_reader :result

    def call
      @result = CartsProduct.where(@attributes)
    end
  end
end
