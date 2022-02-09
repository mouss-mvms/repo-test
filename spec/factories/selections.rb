FactoryBot.define do
  factory :selection do
    name { "voiture" }
    description { "voiture true" }
    begin_date { "2021-07-20 00:00:00" }
    end_date { "2021-07-27 00:00:00" }
    is_home { false }
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

  factory :online_selection2, class: Selection do
    name { 'onlineSelection' }
    slug { 'online-selection' }
    state { 'active' }
    is_event { false }
    begin_date { DateTime.now - 1.days }
    end_date { DateTime.now + 1.days }
    after(:create) do |selection|
      selection.products << create_list(:available_product, 17)
    end
  end
end
