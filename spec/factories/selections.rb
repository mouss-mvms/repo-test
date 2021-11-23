FactoryBot.define do
  factory :selection do
    name { "voiture" }
    description { "voiture true" }
    begin_date { "2021-07-20 00:00:00" }
    end_date { "2021-07-27 00:00:00" }
    is_home { "12:00:00" }
  end
end
