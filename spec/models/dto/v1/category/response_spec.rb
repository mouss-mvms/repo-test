require 'rails_helper'

RSpec.describe Dto::V1::Category::Response do

  describe 'create' do
    context 'All ok' do
      context 'when with_children is false' do
        it 'should return a Dto::V1::Category::Response' do
          category = create(:category)
          result = Dto::V1::Category::Response.create(category)
          children = category.children.to_a
          expect(result).to be_instance_of(Dto::V1::Category::Response)
          expect(result.id).to eq(category.id)
          expect(result.name).to eq(category.name)
          expect(result.slug).to eq(category.slug)
          expect(result.children).to eq(nil)
          expect(result.has_children).to eq(children.present?)
        end
      end

      context 'when with_children is true' do
        it 'should return a Dto::V1::Category::Response' do
          category = create(:category)
          result = Dto::V1::Category::Response.create(category, "true")
          children = category.children.to_a
          expect(result).to be_instance_of(Dto::V1::Category::Response)
          expect(result.id).to eq(category.id)
          expect(result.name).to eq(category.name)
          expect(result.slug).to eq(category.slug)
          expect(result.children).to eq(children)
          expect(result.has_children).to eq(children.present?)
        end
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::Category::Response' do
        category = create(:category)
        dto = Dto::V1::Category::Response.create(category)

        dto_hash = dto.to_h

        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:name]).to eq(dto.name)
        expect(dto_hash[:slug]).to eq(dto.slug)
        expect(dto_hash[:children]).to eq(dto.children)
        expect(dto_hash[:hasChildren]).to eq(dto.has_children)
      end
    end
  end
end