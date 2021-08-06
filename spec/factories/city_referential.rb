FactoryBot.define do
  factory :city_referential do
    insee_code { '64445' }
    name { 'PAU' }
    label { 'Pau' }
    department { '64' }
  end
end
