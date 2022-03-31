# == Schema Information
#
# Table name: shipping_costs
#
#  id         :integer          not null, primary key
#  shop_id    :integer
#  cost       :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#

FactoryBot.define do
  factory :shipping_cost do
    shop
    cost { 1.5 }
    name { "Coucou" }
  end
end