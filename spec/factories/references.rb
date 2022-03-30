# == Schema Information
#
# Table name: references
#
#  id               :integer          not null, primary key
#  base_price       :float
#  quantity         :integer
#  is_visible       :boolean
#  weight           :float
#  shop_id          :integer
#  product_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  good_deal_id     :integer
#  color_id         :integer
#  measure_id       :integer
#  size_id          :integer
#  image_id         :integer
#  sample_id        :integer
#  shipping_cost_id :integer
#

FactoryBot.define do
  factory :reference do
    base_price { 100 }
    quantity { 10 }
    is_visible { false }
    weight { 1.5 }
    association :shop, factory: :old_shop_factory
    color
    size
    association :product, factory: :product
    shipping_cost
    sample
    good_deal
  end
end
