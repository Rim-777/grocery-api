# == Schema Information
#
# Table name: carts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CartSerializer
  include JSONAPI::Serializer

  attribute :total do |cart|
    sum = cart.carts_products.sum(:price)
    Money.new(sum)
  end

  attribute :carts_products do |cart|
    CartsProductSerializer.new(cart.carts_products, include: ['product'])
  end
end
