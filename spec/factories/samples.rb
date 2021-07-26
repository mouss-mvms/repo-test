# == Schema Information
#
# Table name: samples
#
#  id         :integer          not null, primary key
#  product_id :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  default    :boolean
#

FactoryBot.define do
  factory :sample do
    product
    name { "MyString" }
    default { true }
  end
end
