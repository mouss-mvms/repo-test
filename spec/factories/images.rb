FactoryBot.define do
  factory :image do
    file_data { '{"id":"images/unit-tests/foo.png","storage":"store","metadata":{"filename":"foo.png","size":4,"mime_type":"image/png"}}' }
  end
end