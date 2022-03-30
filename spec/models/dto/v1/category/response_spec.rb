require 'rails_helper'

RSpec.describe Dto::V1::Category::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Category::Response' do
        category = create(:category)
        result = Dto::V1::Category::Response.create(category)
        children = category.children.to_a
        expect(result).to be_instance_of(Dto::V1::Category::Response)
        expect(result.id).to eq(category.id)
        expect(result.name).to eq(category.name)
        expect(result.slug).to eq(category.slug)
        expect(result.children).to eq(children)
        expect(result.has_children).to eq(children.present?)
        expect(result.type).to eq(category.group)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      context "when field children is present" do
        it 'should a hash representation of Dto::V1::Category::Response' do
          category = create(:category)
          dto = Dto::V1::Category::Response.create(category)

          dto_hash = dto.to_h({ "children": true })

          expect(dto_hash[:id]).to eq(dto.id)
          expect(dto_hash[:name]).to eq(dto.name)
          expect(dto_hash[:slug]).to eq(dto.slug)
          expect(dto_hash[:children]).to eq(dto.children)
          expect(dto_hash[:hasChildren]).to eq(dto.has_children)
          expect(dto_hash[:type]).to eq(dto.type)
        end
      end

      context "when field children isn't present" do
        it 'should a hash representation of Dto::V1::Category::Response without children' do
          category = create(:category)
          dto = Dto::V1::Category::Response.create(category)

          dto_hash = dto.to_h

          expect(dto_hash[:id]).to eq(dto.id)
          expect(dto_hash[:name]).to eq(dto.name)
          expect(dto_hash[:slug]).to eq(dto.slug)
          expect(dto_hash[:hasChildren]).to eq(dto.has_children)
          expect(dto_hash.has_key?(:children)).to eq(false)
          expect(dto_hash[:type]).to eq(dto.type)
        end
      end
    end
  end
end