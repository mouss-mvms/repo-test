FactoryBot.define do
  factory :privacy_terms, class: PolicyManager::Term do
    description { "test privacy terms" }
    rule { "privacy_terms" }
    state { "published" }
  end
end