require 'rails_helper'

RSpec.describe Dto::GoodDeal::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::GoodDeal::Response' do
        good_deal = create(:good_deal)
        result = Dto::GoodDeal::Response.create(good_deal)

        expect(result).to be_instance_of(Dto::GoodDeal::Response)
        expect(result.start_at).to eq(good_deal.starts_at.strftime('%d/%m/%Y'))
        expect(result.end_at).to eq(good_deal.ends_at.strftime('%d/%m/%Y'))
        expect(result.discount).to eq(good_deal.discount)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::GoodDeal::Response' do
        good_deal = create(:good_deal)
        dto = Dto::GoodDeal::Response.create(good_deal)

        dto_hash = dto.to_h

        expect(dto_hash[:startAt]).to eq(dto.start_at)
        expect(dto_hash[:endAt]).to eq(dto.end_at)
        expect(dto_hash[:discount]).to eq(dto.discount)
      end
    end
  end
end