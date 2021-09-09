require "rails_helper"

RSpec.describe Api::V1::ReviewsController, type: :controller do
  describe "PUT #update" do
    context "All ok" do
      it 'should return 200 HTTP Status with review updated' do
        user = create(:user)
        shop = create(:shop)
        review = create(:review, mark: 4, shop_id: shop.id, content: "Avis non mis à jour", user_id: user.id)
        params = {
          content: "Avis mis à jour"
        }

        request.headers['x-client-id'] = generate_token(user)

        put :update, params: params.merge(id: review.id)

        expect(response).to have_http_status(:ok)

        result = JSON.parse(response.body)
        expect(result["id"]).to eq(review.id)
        expect(result["content"]).to eq(params[:content])
      end
    end

    context 'Bad authentication' do
      context 'x-client-id is missing' do
        it 'should return 401 HTTP Status' do
          user = create(:user)
          shop = create(:shop)
          review = create(:review, mark: 4, shop_id: shop.id, content: "Avis non mis à jour", user_id: user.id)
          params = {
            content: "Avis mis à jour"
          }

          put :update, params: params.merge(id: review.id)

          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context 'User is not the writer of review' do
        it 'should return 403 HTTP Status' do
          user = create(:user)
          user2 = create(:user, email: 'user2@user.com')
          shop = create(:shop)
          review = create(:review, mark: 4, shop_id: shop.id, content: "Avis non mis à jour", user_id: user.id)
          params = {
            content: "Avis mis à jour"
          }

          request.headers['x-client-id'] = generate_token(user2)

          put :update, params: params.merge(id: review.id)

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end

    context 'Bad params' do
      context 'No content' do
        it 'should return 400 HTTP Status' do
          user = create(:user)
          shop = create(:shop)
          review = create(:review, mark: 4, shop_id: shop.id, content: "Avis non mis à jour", user_id: user.id)
          params = {
            content: ""
          }

          request.headers['x-client-id'] = generate_token(user)

          put :update, params: params.merge(id: review.id)

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: content').to_h.to_json)
        end
      end
    end
  end
end
