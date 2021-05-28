FactoryBot.define do
  factory :category do
    name { "Category" }
  end

  factory :category_for_product, class: Category do
    name { "ProductCategory" }
  end
end