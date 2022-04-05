require 'rails_helper'

RSpec.describe Api::V1::Shops::ImagesController, type: :controller do
  describe "#destroy" do
    before(:all) do
      @user_shop_employee = create(:shop_employee_user)
      @user_shop_employee_token = generate_token(@user_shop_employee)
      @shop = create(:shop, owner: @user_shop_employee.shop_employee)
      @user_shop_employee.shop_employee.shops << @shop
      @user_shop_employee.shop_employee.save
    end

    before(:each) do
      @featured ||= create(:image)
      @thumbnail ||=  create(:image)
      @profil ||= create(:image)
      @shop.update(featured: @featured, thumbnail: @thumbnail, profil: @profil)
    end

    after(:all) do
      @user_shop_employee.destroy
      @user_shop_employee_token = nil
      @shop.destroy
    end

    context "All ok" do
      context 'Delete a profil image' do
        it 'should return 204 HTTP Status and image is deleted' do
          request.headers['HTTP_X_CLIENT_ID'] = @user_shop_employee_token

          post :destroy, params: { id: @profil.id}

          expect(response).to have_http_status(:no_content)
          expect(Image.exists?(@profil.id)).to be_falsey
          expect(Image.exists?(@featured.id)).to be_truthy
          expect(Image.exists?(@thumbnail.id)).to be_truthy
          @shop.reload
          expect(@shop.profil.nil?).to be_truthy
          expect(@shop.featured.nil?).to be_falsey
          expect(@shop.thumbnail.nil?).to be_falsey
        end
      end

      context 'Delete a thumbnail image' do
        it 'should return 204 HTTP Status and image is deleted' do
          request.headers['HTTP_X_CLIENT_ID'] = @user_shop_employee_token

          post :destroy, params: { id: @thumbnail.id}

          expect(response).to have_http_status(:no_content)
          expect(Image.exists?(@profil.id)).to be_truthy
          expect(Image.exists?(@featured.id)).to be_truthy
          expect(Image.exists?(@thumbnail.id)).to be_falsey
          @shop.reload
          expect(@shop.profil.nil?).to be_falsey
          expect(@shop.featured.nil?).to be_falsey
          expect(@shop.thumbnail.nil?).to be_truthy
        end
      end

      context 'Delete a featured image' do
        it 'should return 204 HTTP Status and image is deleted' do
          request.headers['HTTP_X_CLIENT_ID'] = @user_shop_employee_token

          post :destroy, params: { id: @featured.id}

          expect(response).to have_http_status(:no_content)
          expect(Image.exists?(@profil.id)).to be_truthy
          expect(Image.exists?(@featured.id)).to be_falsey
          expect(Image.exists?(@thumbnail.id)).to be_truthy
          @shop.reload
          expect(@shop.profil.nil?).to be_falsey
          expect(@shop.featured.nil?).to be_truthy
          expect(@shop.thumbnail.nil?).to be_falsey
        end
      end
    end

    context "Bad authentification" do
      context "No user" do
        it 'should return 401 HTTP Status' do
          post :destroy, params: { id: @profil.id}

          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "User is not a citizen" do
        it 'should return 403 HTTP Status' do
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(create(:citizen_user))

          post :destroy, params: { id: @profil.id}

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end

    context "Image doesn't match with an image of the shop" do
      it 'should return 403 HTTP Status' do
        image = create(:image)
        request.headers['HTTP_X_CLIENT_ID'] = @user_shop_employee_token

        post :destroy, params: { id: image.id }

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
      end
    end
  end
end
