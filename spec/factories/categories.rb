FactoryBot.define do
  factory :category do
    name { "Category" }
    payment_delay { 15 }
  end

  factory :category_for_product, class: Category do
    name { "ProductCategory" }
    payment_delay { 15 }
  end

  factory :homme, class: Category  do
    name { "Homme" }
    payment_delay { 15 }
  end

  factory :femme, class: Category  do
    name { "Femme" }
    payment_delay { 15 }
  end

  factory :others_fresh_desserts, class: Category  do
    id { 2288 }
    name { "Autres desserts frais" }
    payment_delay { 15 }
    position { 0 }
    slug { "alimentation/cremerie/autres-desserts-frais" }
    fresh_state { nil }
    g_shopping_acceptance { true}
    explicit  { nil }
    group { "food" }
  end
end