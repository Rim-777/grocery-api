# frozen_string_literal: true

module CartsProducts
  class DeleteCollection
    prepend BaseOperation

    option :attributes, type: Types::Strict::Hash

    attr_reader :result

    def call
      CartsProduct.where(@attributes).delete_all
    end
  end
end
