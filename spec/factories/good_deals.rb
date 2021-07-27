# == Schema Information
#
# Table name: good_deals
#
#  id         :integer          not null, primary key
#  starts_at  :datetime
#  ends_at    :datetime
#  kind       :string
#  discount   :float            default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :good_deal do
    starts_at { "2015-05-18 14:42:39" }
    ends_at { "2090-05-18 14:42:39" }
    kind { "percentage" }
    discount { 1.5 }
  end
end
