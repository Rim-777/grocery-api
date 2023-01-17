# frozen_string_literal: true

module Api
  module V1
    class ProductsController < BaseController
      def index
        @products = Products::Index.call.result.page(params[:page])

        serializer = ProductSerializer.new(
          @products,
          links: pagination_links(@products)
        )

        render json: serializer.serializable_hash.to_json, status: :ok
      end
    end
  end
end
