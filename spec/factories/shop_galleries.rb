FactoryBot.define do
  factory :shop_gallery do
    shop { nil }
    position { 1 }
    file_data { TestData.image_data }
  end
end