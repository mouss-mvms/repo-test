FactoryBot.define do
  factory :selection do
    name { 'selectionName' }
    slug { 'selectionname' }
    after(:create) do |selection|
      selection.tags << create(:tag)
    end
  end
end