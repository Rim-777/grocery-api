# frozen_string_literal: true

module Api
  module V1
    class CartsController < BaseController
      before_action :validate_params, only: :add_product

      def create
        @cart = Carts::Create.call.result

        render_cart(@cart, :created)
      end

      def show
        @cart = Carts::Show.call(cart_id: params[:id]).result

        render_cart(@cart, :ok)
      end

      def add_product
        operation = Carts::AddProduct.call(**@valid_params.fetch(:data))

        if operation.success?
          render_cart(operation.cart, :created)
        else
          error_response(operation.errors, :unprocessable_entity)
        end
      end

      private

      def validate_params
        validation = AddProductContract.new.call(add_product_params)
        result_validation(validation)
      end

      def add_product_params
        params.permit(data: {}).to_h
      end

      def render_cart(cart, status)
        serializer = CartSerializer.new(cart)

        render json: serializer.serializable_hash.to_json, status: status
      end
    end
  end
end
