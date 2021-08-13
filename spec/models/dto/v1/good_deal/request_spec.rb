require "rails_helper"

RSpec.describe Dto::V1::GoodDeal::Request do
  describe 'new' do
    context 'All ok' do
      it 'should return a Dto::Characteristic::Request' do
        good_deal_params = {
          start_at: "20/01/2021",
          end_at: "16/02/2021",
          discount: "20"
        }

        dto_good_deal = Dto::V1::GoodDeal::Request.new(good_deal_params)

        expect(dto_good_deal).to be_instance_of(Dto::V1::GoodDeal::Request)
        expect(dto_good_deal.start_at).to eq(good_deal_params[:start_at])
        expect(dto_good_deal.end_at).to eq(good_deal_params[:end_at])
        expect(dto_good_deal.discount).to eq(good_deal_params[:discount])
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::GoodDeal::Request' do
        good_deal_params = {
          start_at: "20/01/2021",
          end_at: "16/02/2021",
          discount: "20"
        }

        dto_good_deal = Dto::V1::GoodDeal::Request.new(good_deal_params)
        dto_hash = dto_good_deal.to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:start_at]).to eq(dto_good_deal.start_at)
        expect(dto_hash[:end_at]).to eq(dto_good_deal.end_at)
        expect(dto_hash[:discount]).to eq(dto_good_deal.discount)
      end
    end
  end
end