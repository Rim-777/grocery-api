# frozen_string_literal: true

# == Schema Information
#
# Table name: products_actions
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  action_id  :integer
#  product_id :integer
#
# Indexes
#
#  index_products_actions_on_product_id_and_action_id  (product_id,action_id) UNIQUE
#
FactoryBot.define do
  factory :products_action do
  end
end
