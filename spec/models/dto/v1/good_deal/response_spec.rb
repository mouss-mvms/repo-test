require 'rails_helper'

RSpec.describe Dto::V1::GoodDeal::Response do

  before(:all) do
    @good_deal = create(:good_deal)
  end

  after(:all) do
    @good_deal.destroy
  end

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::GoodDeal::Response' do
        result = Dto::V1::GoodDeal::Response.create(@good_deal)

        expect(result).to be_instance_of(Dto::V1::GoodDeal::Response)
        expect(result.start_at).to eq(@good_deal.starts_at.strftime('%d/%m/%Y'))
        expect(result.end_at).to eq(@good_deal.ends_at.strftime('%d/%m/%Y'))
        expect(result.discount).to eq(@good_deal.discount)
      end
    end
  end

  describe 'from_reference' do
    context 'All ok' do
      it 'should return a Dto::V1::GoodDeal::Response' do
        reference = create(:reference,
                           base_price: 15,
                           good_deal: create(:good_deal,
                                             starts_at: (DateTime.now-2),
                                             ends_at: (DateTime.now+2),
                                             discount: 20))

        result = Dto::V1::GoodDeal::Response.from_reference(reference)

        expect(result).to be_instance_of(Dto::V1::GoodDeal::Response)
        expect(result.start_at).to eq(reference.good_deal.starts_at.strftime('%d/%m/%Y'))
        expect(result.end_at).to eq(reference.good_deal.ends_at.strftime('%d/%m/%Y'))
        expect(result.discount).to eq(reference.good_deal.discount)
        expect(result.discounted_price).to eq(reference.base_price - (reference.base_price*(reference.good_deal.discount/100)))
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::GoodDeal::Response' do
        dto = Dto::V1::GoodDeal::Response.create(@good_deal)

        dto_hash = dto.to_h

        expect(dto_hash[:startAt]).to eq(dto.start_at)
        expect(dto_hash[:endAt]).to eq(dto.end_at)
        expect(dto_hash[:discount]).to eq(dto.discount)
        expect(dto_hash[:discountedPrice]).to eq(dto.discounted_price)
      end
    end
  end
end