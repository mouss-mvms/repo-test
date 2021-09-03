FactoryBot.define do
  factory :service do
    name { "MyString" }
    fixed_price { 3 }
    express { false }
    shop_dependent { false }
    is_delivery { true }
  end
  factory :service2, class: Service do
    name { "service_2" }
    fixed_price { 3 }
    express { true }
    shop_dependent { false }
  end
  factory :service3, class: Service do
    name { "service_3" }
    fixed_price { 3 }
    express { true }
    shop_dependent { false }
  end

  factory :service_delivery, class: Service do
    name { "service_3" }
    fixed_price { 3 }
    express { true }
    shop_dependent { false }
    is_delivery { true }
  end

  factory :service_not_delivery, class: Service do
    name { "service_3" }
    fixed_price { 3 }
    express { true }
    shop_dependent { false }
    is_delivery { false }
  end
end
