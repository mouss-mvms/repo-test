require "rails_helper"

RSpec.describe Dto::Characteristic::Request do
  describe 'new' do
    context 'All ok' do
      it 'should return a Dto::Characteristic::Request' do
        characteristic_params = {
          name: "color",
          value: "blue"
        }

        dto_characteristic = Dto::Characteristic::Request.new(characteristic_params)

        expect(dto_characteristic).to be_instance_of(Dto::Characteristic::Request)
        expect(dto_characteristic.name).to eq(characteristic_params[:name])
        expect(dto_characteristic.value).to eq(characteristic_params[:value])
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::Characteristic::Request' do
        characteristic_params = {
          name: "color",
          value: "blue"
        }

        dto_characteristic = Dto::Characteristic::Request.new(characteristic_params)
        dto_hash = dto_characteristic.to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:name]).to eq(dto_characteristic.name)
        expect(dto_hash[:value]).to eq(dto_characteristic.value)
      end
    end
  end
end