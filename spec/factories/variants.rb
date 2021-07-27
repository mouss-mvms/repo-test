FactoryBot.define do
  factory :variant do
    base_price { 19.9 }
    weight { 0.24 }
    quantity { 4 }
    is_default { true }
    good_deal
    after :create do |variant|
      variant.characteristics << FactoryBot.create(:characteristic)
    end
  end
end
