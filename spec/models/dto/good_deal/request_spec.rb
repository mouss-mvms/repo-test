require "rails_helper"

RSpec.describe Dto::GoodDeal::Request do
  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::Characteristic::Request' do
        good_deal = create(:good_deal)
        good_deal_params = {
          start_at: good_deal.starts_at,
          end_at: good_deal.ends_at,
          discount: good_deal.discount,
        }

        result = Dto::GoodDeal::Request.new(good_deal_params)

        expect(result).to be_instance_of(Dto::GoodDeal::Request)
        expect(result.start_at).to eq(good_deal.starts_at)
        expect(result.end_at).to eq(good_deal.ends_at)
        expect(result.discount).to eq(good_deal.discount)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::GoodDeal::Request' do
        good_deal = create(:good_deal)
        good_deal_params = {
          start_at: good_deal.starts_at,
          end_at: good_deal.ends_at,
          discount: good_deal.discount,
        }

        dto_hash = Dto::GoodDeal::Request.new(good_deal_params).to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:start_at]).to eq(good_deal.starts_at)
        expect(dto_hash[:end_at]).to eq(good_deal.ends_at)
        expect(dto_hash[:discount]).to eq(good_deal.discount)
      end
    end
  end
end