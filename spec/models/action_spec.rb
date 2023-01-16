# frozen_string_literal: true

# == Schema Information
#
# Table name: actions
#
#  id             :bigint           not null, primary key
#  bonus_quantity :integer          default(0), not null
#  coefficient    :decimal(12, 10)  default(1.0), not null
#  min_quantity   :integer          not null
#  type           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_actions_on_type  (type)
#
require 'rails_helper'

RSpec.describe Action, type: :model do
  it 'associates action with products_actions' do
    should have_many(:products_actions)
      .class_name(ProductsAction.name)
      .inverse_of(:action)
      .dependent(:destroy)
  end

  it 'associates action with products' do
    should have_many(:products).through(:products_actions)
  end
end
