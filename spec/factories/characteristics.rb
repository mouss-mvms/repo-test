# == Schema Information
#
# Table name: characteristics
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#

FactoryBot.define do
  factory :characteristic do
    name { "color" }
    value { "red"}
  end
end