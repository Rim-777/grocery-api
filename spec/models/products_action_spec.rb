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
require 'rails_helper'

RSpec.describe ProductsAction, type: :model do
  it { should belong_to(:action).inverse_of(:products_actions) }
  it { should belong_to(:product).inverse_of(:products_actions) }
  it { should validate_uniqueness_of(:product_id).scoped_to(:action_id) }
end
