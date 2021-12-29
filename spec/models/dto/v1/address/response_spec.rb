# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dto::V1::Address::Response do
  describe "create" do
    context 'All ok' do
      it 'returns a Dto::V1::Address::Response' do
        address = create(:address)
        dto_response = Dto::V1::Address::Response.create(address)

        expect(dto_response).to be_an_instance_of(Dto::V1::Address::Response)
        expect(dto_response.street_number).to eq(address.street_number)
        expect(dto_response.route).to eq(address.route)
        expect(dto_response.locality).to eq(address.locality)
        expect(dto_response.country).to eq(address.country)
        expect(dto_response.postal_code).to eq(address.postal_code)
        expect(dto_response.latitude).to eq(address.latitude)
        expect(dto_response.latitude).to eq(address.latitude)
        expect(dto_response.insee_code).to eq(address.city.insee_code)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should returns a respresentation hash of Dto::V1::Address::Response' do
        address = create(:address)
        dto_response = Dto::V1::Address::Response.create(address)
        dto_hash = dto_response.to_h

        expect(dto_hash).to be_an_instance_of(Hash)
        expect(dto_hash[:streetNumber]). to eq(dto_response.street_number)
        expect(dto_hash[:route]). to eq(dto_response.route)
        expect(dto_hash[:locality]). to eq(dto_response.locality)
        expect(dto_hash[:country]). to eq(dto_response.country)
        expect(dto_hash[:postalCode]). to eq(dto_response.postal_code)
        expect(dto_hash[:latitude]). to eq(dto_response.latitude)
        expect(dto_hash[:longitude]). to eq(dto_response.longitude)
        expect(dto_hash[:inseeCode]). to eq(dto_response.insee_code)
      end
    end
  end
end
