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
    latitude { "latitude" }
    longitude { "longitude" }
  end
end
