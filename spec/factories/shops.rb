FactoryBot.define do
  factory :shop do
    name { "Boutique test" }
    email { 'email-boutique-test@test.fr'}
    siret { '75409821800029' }
  end

  factory :old_shop_factory, class: Shop do
    name { "gallazini" }
    siret { "434189163" }
    iban { "FR76 1820 6002 1054 8726 6700 217" }
    swift { "SOGEFRPP" }
    is_group { false }
    slug { "gallazini" }
    email { "contact@michaelvilleneuve.fr" }
    mobile_phone_number { '0666666666' }
    free_shipping_limit { 500 }
    is_self_delivery { true }
    after(:create) do |shop|
      shop.addresses << create(:address, addressable: shop)
    end
  end
end