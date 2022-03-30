FactoryBot.define do
  factory :territory do
    name { "Territoire des apaches" }
    slug { "territoire-des-apaches" }
    after(:create) do |territory|
      city = create(:old_city_factory)
      territory.cities << city
    end
  end
end