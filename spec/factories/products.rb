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
    archived { false }
    status { 1 }
    category
    shop
  end

  factory :available_product, class: Product do
    name { "MyString" }
    archived { false }
    status { 1 }
    shop
    category
    after :create do |product|
      shop = product.shop
      product.references << FactoryBot.create(:reference, sample: create(:sample, product: product), product: nil, shop: shop)
      product.references << FactoryBot.create(:reference, sample: create(:sample, product: product), product: nil, shop: shop)
    end
    created_at { Date.new(2019, 8, 30) }
  end

  factory :product_created_by_citizen, class: Product do
    name { "MyString" }
    archived { false }
    status { 2 }
    shop
    category
  end

end
