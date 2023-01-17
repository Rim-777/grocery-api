ActiveRecord::Base.transaction do
  green_tee_cation = Action::Bonus.find_or_create_by!(bonus_quantity: 1, min_quantity: 0)
  strawberries_cation = Action::Discount.find_or_create_by!(min_quantity: 3, coefficient: 0.9)
  coffee_cation = Action::Discount.find_or_create_by!(min_quantity: 3, coefficient: 0.6666666667)


  product_entities = [
    {
      attributes: {
        code: 'GR1', name: 'Green Tea', price: Money.new(3.11)
      },
      action: green_tee_cation
    },
    {
      attributes: {code: 'SR1', name: 'Strawberries', price: Money.new(5.00) },
      action: strawberries_cation
    },
    {
      attributes: {code: 'CF1', name: 'Coffee', price: Money.new(11.23) },
      action: coffee_cation
    }
  ]

  product_entities.each do |product_entity|
    new_product =  Product.find_or_create_by!(product_entity.fetch(:attributes))
    new_product.actions = [product_entity.fetch(:action)]
  end
end
