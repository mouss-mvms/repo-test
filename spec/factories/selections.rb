FactoryBot.define do
  factory :selection do
    name { 'selectionName' }
    slug { 'selectionname' }
    after(:create) do |selection|
      selection.tags << create(:tag)
    end
  end

  factory :online_selection, class: Selection do
    name { 'onlineSelection' }
    slug { 'online-selection' }
    state { 'active' }
    is_event { false }
    begin_date { DateTime.now - 1.days }
    end_date { DateTime.now + 1.days }
    after(:create) do |selection|
      selection.products << create(:available_product)
    end
  end
end
