# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#  brand_id    :integer
#  citizen_id  :integer
#

FactoryBot.define do
  factory :product do
    name { "MyString" }
    slug { "my-string" }
    archived { false }
    status { 1 }
    category
    shop
  end

  factory :product_with_category, class: Product do
    name { "MyString" }
    slug { "my-string" }
    archived { false }
    status { 1 }
    association :category, factory: :category
    shop
  end

  factory :available_product, class: Product do
    name { "MyString" }
    slug { "my-string" }
    archived { false }
    status { 1 }
    shop
    category
    after :create do |product|
      product.references << FactoryBot.create(:reference)
      product.references << FactoryBot.create(:reference)
    end
    created_at { Date.new(2019, 8, 30) }
  end

  factory :product_without_services, class: Product do
    name { "product_with_services1" }
    slug { "product-with-services" }
    archived { false }
    status { 1 }
    shop
    category
    after :create do |product|
      product.references << FactoryBot.create(:reference_without_services)
    end
  end
  factory :product_without_services2, class: Product do
    name { "product_with_services2" }
    slug { "product-with-services" }
    archived { false }
    status { 1 }
    shop
    category
    after :create do |product|
      product.references << FactoryBot.create(:reference_without_services2)
    end
  end

  factory :product_offline, class: Product do
    name { "MyString" }
    slug { "my-string" }
    archived { false }
    status { 0 }
    category
    shop
  end

  factory :product_created_by_citizen, class: Product do
    name { "MyString" }
    slug { "my-string" }
    archived { false }
    status { 2 }
    shop
    category
  end

  factory :product_without_name, class: Product do
    slug { "my-string" }
    archived { false }
    status { 1 }
    category
    shop
  end
end
