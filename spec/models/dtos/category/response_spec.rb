require 'rails_helper'

RSpec.describe Dto::Category::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::Category::Response' do
        category = create(:category)
        result = Dto::Category::Response.create(category)
        expect(result).to be_instance_of(Dto::Category::Response)
        expect(result.id).to eq(category.id)
        expect(result.name).to eq(category.name)
        expect(result.slug).to eq(category.slug)
        expect(result.children).to eq([])
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::Category::Response' do
        category = create(:category)
        dto = Dto::Category::Response.create(category)

        dto_hash = dto.to_h

        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:name]).to eq(dto.name)
        expect(dto_hash[:slug]).to eq(dto.slug)
      end
    end
  end
end