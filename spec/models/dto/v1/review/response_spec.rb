require 'rails_helper'

RSpec.describe Dto::V1::Review::Response do
  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Review::Response' do
        user_citizen = create(:citizen_user)
        user_shop_employee = create(:shop_employee_user)
        shop = create(:shop)
        shop.owner = user_shop_employee.shop_employee
        shop.save
        review = create(:review, shop_id: shop.id, user_id: user_citizen.id, content: "Boutique Super", mark: 5)
        answer = create(:review, shop_id: shop.id, user_id: user_shop_employee.id, parent_id: review.id, content: "Merci :) !")

        result = Dto::V1::Review::Response.create(review)

        expect(result).to be_instance_of(Dto::V1::Review::Response)
        expect(result.id).to eq(review.id)
        expect(result.mark).to eq(review.mark)
        expect(result.content).to eq(review.content)
        expect(result.shop_id).to eq(review.shop_id)
        expect(result.product_id).to eq(review.product_id)
        expect(result.user_id).to eq(review.user_id)
        expect(result.parent_id).to eq(review.parent_id)
        expect(result.answers.count).to eq(review.answers.count)
        result.answers.each do |response_answer|
          review_answer = review.answers.to_a.find { |a| a.id == response_answer.id }
          expect(review_answer).not_to be_nil
          expect(response_answer.id).to eq(review_answer.id)
          expect(response_answer.mark).to eq(review_answer.mark)
          expect(response_answer.content).to eq(review_answer.content)
          expect(response_answer.shop_id).to eq(review_answer.shop_id)
          expect(response_answer.product_id).to eq(review_answer.product_id)
          expect(response_answer.user_id).to eq(review_answer.user_id)
          expect(response_answer.parent_id).to eq(review_answer.parent_id)
        end
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should return a hash representation of Dto::V1::Review::Response' do
        user_citizen = create(:citizen_user)
        user_shop_employee = create(:shop_employee_user)
        shop = create(:shop)
        shop.owner = user_shop_employee.shop_employee
        shop.save
        review = create(:review, shop_id: shop.id, user_id: user_citizen.id, content: "Boutique Super", mark: 5)
        answer = create(:review, shop_id: shop.id, user_id: user_shop_employee.id, parent_id: review.id, content: "Merci :) !")
        dto = Dto::V1::Review::Response.create(review)

        result = dto.to_h

        expect(result).to be_instance_of(Hash)
        expect(result[:id]).to eq(dto.id)
        expect(result[:mark]).to eq(dto.mark)
        expect(result[:productId]).to eq(dto.product_id)
        expect(result[:shopId]).to eq(dto.shop_id)
        expect(result[:userId]).to eq(dto.user_id)
        expect(result[:content]).to eq(dto.content)
        expect(result[:parentId]).to eq(dto.parent_id)
        expect(result[:answers]).to eq(dto.answers)
      end
    end
  end
end
