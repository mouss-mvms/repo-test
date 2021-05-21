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
    shop
    association :product, factory: :product
    shipping_cost
    sample
    good_deal { nil }
    after :create do |reference|
      reference.services << Service.all.first || FactoryBot.create(:service)
    end
  end

  factory :reference_service_2, class: Reference do
    base_price { 100 }
    quantity { 10 }
    is_visible { false }
    weight { 1.5 }
    shop
    product
    shipping_cost
    good_deal { nil }
    after :create do |reference|
      reference.services << Service.all.second || FactoryBot.create(:service2)
    end
  end
  factory :reference_without_services, class: Reference do
    base_price { 10 }
    quantity { 10 }
    is_visible { false }
    weight { 1.5 }
    shop
    product
    shipping_cost
    good_deal { nil }
  end
  factory :reference_without_services2, class: Reference do
    base_price { 100 }
    quantity { 10 }
    is_visible { false }
    weight { 1.5 }
    shop
    product
    shipping_cost
    good_deal { nil }
  end

  factory :reference_with_fresh, class: Reference do
    base_price { 100 }
    quantity { 10 }
    is_visible { false }
    weight { 1.5 }
    shop
    association :product, factory: :product_with_category
    shipping_cost
    sample
    good_deal { nil }
    after :create do |reference|
      reference.services << Service.all.first || FactoryBot.create(:service)
    end
  end
end
