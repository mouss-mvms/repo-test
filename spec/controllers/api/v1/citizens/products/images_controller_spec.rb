require 'rails_helper'

RSpec.describe Api::V1::Citizens::Products::ImagesController, type: :controller do
  describe "DELETE #destroy" do
    before(:all) do
      @citizen_user = create(:citizen_user)
      @citizen = @citizen_user.citizen
      @product = create(:available_product, status: 3)
      @product.citizens << @citizen
      @reference = @product.references.first
      @sample = @reference.sample
      @shop = @product.shop
    end
    after(:all) do
      @shop.products.destroy_all
      @shop.destroy
      @citizen_user.destroy
    end

    context 'All ok' do
      it "should return http status 204 and destroy the image" do
        image = create(:image)
        @sample.images << image
        request.headers['x-client-id'] = generate_token(@citizen_user)
        delete :destroy, params: { product_id: @product.id, id: image.id }
        expect(response).to have_http_status(204)
        expect(Image.where(id: image.id).first).to eq(nil)
      end
    end

    context "Errors" do
      context "Bad product status" do
        before(:all) do
          @product_bad = create(:available_product, shop: @shop)
          @reference_bad = @product.references.first
          @sample_bad = @reference.sample
          @shop_bad = @product.shop
          @product_bad.citizens << @citizen
        end

        context "Product has draft_cityzen status" do
          it "should return HTTP status 403" do
            image = create(:image)
            @sample_bad.images << image
            request.headers['x-client-id'] = generate_token(@citizen_user)
            delete :destroy, params: { product_id: @product_bad.id, id: image.id }
            expect(response).to have_http_status(403)
            expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          end
        end

        context "Product has refused status" do
          it "should return HTTP status 403" do
            image = create(:image)
            @sample_bad.images << image
            request.headers['x-client-id'] = generate_token(@citizen_user)
            delete :destroy, params: { product_id: @product_bad.id, id: image.id }
            expect(response).to have_http_status(403)
            expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          end
        end
      end

      context 'Not found' do
        context "when image didn't exit" do
          it "should return HTTP status 404" do
            image = create(:image)
            image.sample = @sample
            image.destroy
            request.headers['x-client-id'] = generate_token(@citizen_user)
            delete :destroy, params: { product_id: @product.id, id: image.id }
            expect(response).to have_http_status(404)
            expect(response.body).to eq(Dto::Errors::NotFound.new("Could not find Image with id: #{image.id} for product_id: #{@product.id}").to_h.to_json)
          end
        end
      end

      context "Bad Authentication" do
        context "without x-client-id" do
          it "should respond with HTTP STATUS 401" do
            delete :destroy, params: { product_id: 0, id: 0 }
            expect(response).to have_http_status(401)
            expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
          end
        end
      end

      context "Bad Authorization" do

        context "when user is a customer" do
          it "should respond with HTTP STATUS 403" do
            request.headers['x-client-id'] = generate_token(create(:customer_user))
            delete :destroy, params: { product_id: 0, id: 0 }
            expect(response).to have_http_status(403)
            expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          end
        end

        context "when user is a admin" do
          it "should respond with HTTP STATUS 403" do
            request.headers['x-client-id'] = generate_token(create(:admin_user))
            delete :destroy, params: { product_id: 0, id: 0 }
            expect(response).to have_http_status(403)
            expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          end
        end
      end
    end
  end
end


