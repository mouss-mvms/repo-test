FactoryBot.define do
  factory :city do
    name { "Pau" }
    slug { "pau" }
    zip_code { 64000 }
    status { :active }
    insee_code { '64445' }
    before(:create) do |city|
      create(:city_referential)
    end
  end
end
