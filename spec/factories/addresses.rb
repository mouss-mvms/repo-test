FactoryBot.define do
  factory :address do
    lastname { "prenom" }
    firstname { "prenom" }
    phone_number { "038429482" }
    label { "MyString" }
    street_number { 38 }
    route { "avenue du général Leclerc" }
    postal_code { "64000" }
    locality { "Pau" }
    country { "France" }
    is_default { false }
    latitude { 45.79923399999999 }
    longitude { 4.8470666 }
    after :create do |address|
      address.city = FactoryBot.create(:old_city_factory)
    end
  end
end
