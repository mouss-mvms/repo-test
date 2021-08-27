FactoryBot.define do
  factory :shop_gallery do
    shop { nil }
    position { 1 }
    file_data { '{"id":"images/unit-tests/foo.png","storage":"store","metadata":{"filename":"foo.png","size":4,"mime_type":"image/png"}}' }
  end
end