FactoryBot.define do
  factory :category do
    name { "Category" }
    payment_delay { 15 }
  end

  factory :category_for_product, class: Category do
    name { "ProductCategory" }
    payment_delay { 15 }
  end
end