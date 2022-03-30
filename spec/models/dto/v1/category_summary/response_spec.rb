require 'rails_helper'

RSpec.describe Dto::V1::CategorySummary::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Category::Response' do
        result = Dto::V1::CategorySummary::Response.create(category, { children: false })

        expect(result).to be_instance_of(Dto::V1::CategorySummary::Response)
        expect(result.id).to eq(category.id)
        expect(result.name).to eq(category.name)
        expect(result.slug).to eq(category.slug)
        expect(result.children).to eq([])
        expect(result.has_children).to eq(category.has_children)
        expect(result.type).to eq(category.group)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      context "when field children isn't present" do
        it 'should a hash representation of Dto::V1::Category::Response without children' do
          dto = Dto::V1::CategorySummary::Response.create(category, { children: false })

          dto_hash = dto.to_h

          expect(dto_hash[:id]).to eq(dto.id)
          expect(dto_hash[:name]).to eq(dto.name)
          expect(dto_hash[:slug]).to eq(dto.slug)
          expect(dto_hash[:hasChildren]).to eq(dto.has_children)
          expect(dto_hash[:type]).to eq(dto.type)
          expect(dto_hash.has_key?(:children)).to eq(false)
        end
      end
    end
  end

  def category
    Searchkick::HashWrapper.new(
      { "id" => 2278,
        "parent_id" => nil,
        "parent_name" => nil,
        "name" => "Vin et spiritueux",
        "slug" => "vin-et-spiritueux",
        "group" => "alcohol",
        "has_children" => true,
        "updated_at" => "2021-11-17T12:21:15.130+01:00",
        "tree_ids" => [2278],
        "tree_names" => ["Vin et spiritueux"] }
    )
  end
end