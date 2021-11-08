FactoryBot.define do
  factory :territory do
    name { "Territoire des apaches" }
    slug { "territoire-des-apaches" }
    after(:create) do |territory|
      city = create(:city)
      territory.cities << city
    end
  end
end