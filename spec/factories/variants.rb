FactoryBot.define do
    factory :variant do
      base_price { 15 }
      quantity { 10 }
      is_default { true }
      status { 1 }
      product
    end
end