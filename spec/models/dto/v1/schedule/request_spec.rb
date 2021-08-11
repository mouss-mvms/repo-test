require 'rails_helper'

RSpec.describe Dto::V1::Schedule::Request do
  describe 'to_h' do
    context 'when condition' do
      it 'should return a hash representation of Dto::Schedule::Request' do
        params = { id: 5, open_morning: '09:00', close_morning: '12:00', open_afternoon: '14:00', close_afternoon: '19:00' }
        dto = Dto::V1::Schedule::Request.new(params)

        dto_hash = dto.to_h

        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:open_morning]).to eq(params[:open_morning])
        expect(dto_hash[:open_afternoon]).to eq(params[:open_afternoon])
        expect(dto_hash[:close_morning]).to eq(params[:close_morning])
        expect(dto_hash[:close_afternoon]).to eq(params[:close_afternoon])
      end
    end
  end
end