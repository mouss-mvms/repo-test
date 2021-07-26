require "rails_helper"

RSpec.describe Dto::Characteristic::Request do
  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::Characteristic::Request' do
        characteristic = create(:characteristic)
        characteristic_params = {
          name: characteristic.name,
          value: characteristic.value
        }

        result = Dto::Characteristic::Request.new(characteristic_params)

        expect(result).to be_instance_of(Dto::Characteristic::Request)
        expect(result.name).to eq(characteristic.name)
        expect(result.value).to eq(characteristic.value)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::Characteristic::Request' do
        characteristic = create(:characteristic)
        characteristic_params = {
          name: characteristic.name,
          value: characteristic.value
        }

        dto_hash = Dto::Characteristic::Request.new(characteristic_params).to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:name]).to eq(characteristic.name)
        expect(dto_hash[:value]).to eq(characteristic.value)
      end
    end
  end
end