require "rails_helper"

RSpec.describe Api::V1::Shops::ReviewsController, type: :controller do
  describe "GET #index" do
    context "All ok" do
      it "returns an array of reviews" do
        shop = create(:shop)
        user = create(:user)
        shop.reviews << [create(:review, mark: 5, user_id: user.id, content: "Love this shop."), create(:review, mark: 4, user_id: user.id, content: "Like this product.")]

        get :index, params: { id: shop.id }
        should respond_with(200)
        response_body = JSON.load(response.body)
        expect(response_body).to be_an_instance_of(Array)
        expect(response_body.count).to eq(2)
      end

      it "should return HTTP status 304" do
        shop = create(:shop)
        user = create(:user)
        shop.reviews << [create(:review, mark: 5, user_id: user.id, content: "Love this shop."), create(:review, mark: 4, user_id: user.id, content: "Like this product.")]

        get :index, params: { id: shop.id }
        should respond_with(200)

        etag = response.headers["ETag"]
        request.env["HTTP_IF_NONE_MATCH"] = etag
        get :index, params: { id: shop.id }
        should respond_with(304)
      end
    end

    context "Bad params" do
      context "Shop doesn't exists" do
        it "should return 404 HTTP status" do
          get :index, params: { id: 0 }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{response.request.params[:id]}").to_h.to_json)
        end
      end
    end
  end


  describe 'POST #create' do
    context 'All ok' do
      it 'should return 201 HTTP Status with review' do
        user = create(:citizen_user)
        shop = create(:shop)
        params = {
          content: "Avis de la boutique",
          mark: 4
        }

        request.headers['x-client-id'] = generate_token(user)

        post :create, params: params.merge(id: shop.id)

        expect(response).to have_http_status(:created)
        result = JSON.parse(response.body).symbolize_keys
        expect(result[:content]).to eq(params[:content])
        expect(result[:shopId]).to eq(shop.id)
        expect(result[:mark]).to eq(params[:mark])
        expect(result[:userId]).to eq(user.id)
        expect(result[:parentId]).to be_nil
        expect(result[:productId]).to be_nil
      end

      context 'Answer to a review' do
        it "should return a 201 HTTP Status with answer's response" do
          user_citizen = create(:citizen_user)
          user_shop_employee = create(:shop_employee_user)
          shop = create(:shop)
          review = create(:review, user_id: user_citizen.id, shop_id: shop.id, content: 'La boutique est trop bien', mark: 5)
          params = {
            content: "Merci :)",
            parentId: review.id
          }

          request.headers['x-client-id'] = generate_token(user_shop_employee)

          post :create, params: params.merge(id: shop.id)

          expect(response).to have_http_status(:created)
          result = JSON.parse(response.body).symbolize_keys
          expect(result[:content]).to eq(params[:content])
          expect(result[:productId]).to eq(params[:productId])
          expect(result[:userId]).to eq(user_shop_employee.id)
          expect(result[:parentId]).to eq(params[:parentId])
          expect(result[:shopId]).to eq(shop.id)
          expect(review.answers.to_a.find { |a| a.id == result[:id]}).to be_truthy
        end
      end
    end

    context 'Bad params' do
      context 'content is not setted' do
        it 'should return a 400 HTTP Status' do
          user = create(:citizen_user)
          shop = create(:shop)
          params = {
            shopId: shop.id,
            mark: 4
          }

          request.headers['x-client-id'] = generate_token(user)

          post :create, params: params.merge(id: shop.id)

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: content").to_h.to_json)
        end
      end

      context 'review is not an answer to another review' do
        context 'mark is not setted' do
          it 'should return a 400 HTTP Status' do
            user = create(:citizen_user)
            shop = create(:shop)
            params = {
              content: "Avis de la boutique",
              shopId: shop.id
            }

            request.headers['x-client-id'] = generate_token(user)

            post :create, params: params.merge(id: shop.id)

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: mark").to_h.to_json)
          end
        end

        context 'mark is upper than 5' do
          it 'should return a 400 HTTP Status' do
            user = create(:citizen_user)
            shop = create(:shop)
            params = {
              content: "Avis de la boutique",
              shopId: shop.id,
              mark: 6
            }

            request.headers['x-client-id'] = generate_token(user)

            post :create, params: params.merge(id: shop.id)

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("mark must be between 0 and 5").to_h.to_json)
          end
        end

        context 'mark is lower than 5' do
          it 'should return a 400 HTTP Status' do
            user = create(:citizen_user)
            shop = create(:shop)
            params = {
              content: "Avis de la boutique",
              shopId: shop.id,
              mark: -1
            }

            request.headers['x-client-id'] = generate_token(user)

            post :create, params: params.merge(id: shop.id)

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("mark must be between 0 and 5").to_h.to_json)
          end
        end
      end

      context 'review is an answer another review' do
        context 'mark is setted' do
          it 'should return 400 HTTP Status' do
            user_citizen = create(:citizen_user)
            user_shop_employee = create(:shop_employee_user)
            shop = create(:shop)
            review = create(:review, user_id: user_citizen.id, shop_id: shop.id, content: 'La boutique est trop bien', mark: 5)
            params = {
              content: "Merci :)",
              shopId: shop.id,
              parentId: review.id,
              mark: 4
            }

            request.headers['x-client-id'] = generate_token(user_shop_employee)

            post :create, params: params.merge(id: shop.id)

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("mark is not required").to_h.to_json)

          end
        end
      end

      context 'Shop setted is not exist' do
        it 'should return 404 HTTP Status' do
          user = create(:citizen_user)
          shop = create(:shop)
          params = {
            content: "Avis de la boutique",
            shopId: 0,
            mark: 4
          }

          request.headers['x-client-id'] = generate_token(user)

          post :create, params: params.merge(id: 0)

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{response.request.params[:id]}").to_h.to_json)
        end
      end

    end

    context 'Bad Authentication' do
      context 'x-client-id is missing' do
        it 'should return 401 HTTP Status' do
          user = create(:citizen_user)
          shop = create(:shop)
          params = {
            content: "Avis de la boutique",
            shopId: shop.id,
            mark: 4
          }

          post :create, params: params.merge(id: shop.id)

          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context 'User not found' do
        it 'should return 403 HTTP Status' do
          user = create(:citizen_user)
          shop = create(:shop)
          params = {
            content: "Avis de la boutique",
            shopId: shop.id,
            mark: 4
          }

          request.headers['x-client-id'] = generate_token(user)
          User.destroy_all

          post :create, params: params.merge(id: shop.id)

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end
end
