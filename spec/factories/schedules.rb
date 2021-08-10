FactoryBot.define do
  factory :schedule do
    day { 1 }
    open { true }
    am_open { "09:00:00" }
    am_close { "12:00:00" }
    pm_open { "14:00:00" }
    pm_close { "18:00:00" }
    shop { nil }
  end
end
