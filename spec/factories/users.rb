FactoryBot.define do
  factory :user do
    email { "contact@ecity.fr" }
    password { "Azerty123!" }
    password_confirmation { "Azerty123!" }
    landline_phone_number { "0559352565" }
    mobile_phone_number { "0635424475" }
    confirmed_at { "22/06/2016" }
  end

  factory :admin_user, class: User do
    email { 'admin@ecity.fr' }
    password { "Azerty123!" }
    password_confirmation { "Azerty123!" }
    landline_phone_number { "0559352565" }
    mobile_phone_number { "0635424475" }
    confirmed_at { "22/06/2016" }
    admin
  end

  factory :customer_user, class: User do
    email { 'customer@ecity.fr' }
    password { 'Azerty123!' }
    password_confirmation { 'Azerty123!' }
    landline_phone_number { "0559352565" }
    mobile_phone_number { "0635424475" }
    confirmed_at { "22/06/2016" }
    customer
  end

  factory :shop_employee_user, class: User do
    email { "shop.employee@ecity.fr" }
    password { "Azerty123!" }
    password_confirmation { "Azerty123!" }
    landline_phone_number { "0559352565" }
    mobile_phone_number { "0635424475" }
    confirmed_at { "22/06/2016" }
    shop_employee
  end

  factory :citizen_user, class: User do
    email { 'citizen@ecity.fr' }
    password { 'Azerty123!' }
    password_confirmation { 'Azerty123!' }
    landline_phone_number { "0559352565" }
    mobile_phone_number { "0635424475" }
    confirmed_at { "22/06/2016" }
    customer
    citizen
  end
end
