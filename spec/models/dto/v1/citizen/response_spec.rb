require 'rails_helper'

RSpec.describe Dto::V1::Citizen::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Citizen::Response' do
        citizen = create(:citizen, nickname: 'test')

        result = Dto::V1::Citizen::Response.create(citizen)

        expect(result).to be_instance_of(Dto::V1::Citizen::Response)
        expect(result.id).to eq(citizen.id)
        expect(result.nick_name).to eq(citizen.nickname)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should return a hash representation of Dto::V1::Citizen::Response' do
        citizen_response = Dto::V1::Citizen::Response.new({id: 5, nick_name: 'niquename'})

        dto_hash = citizen_response.to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:id]).to eq(citizen_response.id)
        expect(dto_hash[:nickName]).to eq(citizen_response.nick_name)
      end
    end
  end

end
