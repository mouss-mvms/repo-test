require 'rails_helper'

RSpec.describe Api::V1::VariantsController, type: :controller do

  describe "PATCH #update" do
    context "All ok" do

      context "when the user is the shop owner" do
        it 'should return 200 HTTP status code with the updated variant' do
          user_shop_employee = create(:shop_employee_user, email: "shop.employee3@ecity.fr")
          reference = create(:reference)
          product = reference.product
          user_shop_employee.shop_employee.shops << product.shop
          user_shop_employee.shop_employee.save
          request.headers["x-client-id"] = generate_token(user_shop_employee)
          uploaded_file = fixture_file_upload(Rails.root.join("spec/fixtures/files/images/harry-and-marv.jpg"), 'image/jpeg')
          patch :update, params: variant_params.merge(id:  reference.id, files: [uploaded_file])
          should respond_with(200)
          result = JSON.parse(response.body, symbolize_names: true)
          expect(result[:basePrice]).to eq(variant_params[:basePrice])
          expect(result[:weight]).to eq(variant_params[:weight])
          expect(result[:quantity]).to eq(variant_params[:quantity])
          expect(result[:isDefault]).to eq(variant_params[:isDefault])
          expect(result[:goodDeal]).to eq(variant_params[:goodDeal])
          expect(result[:imageUrls]).to_not be_nil
          variant_params_mapped = variant_params[:characteristics].map { |c| [ c[:value], c[:name] ] }
          result[:characteristics].each do |charac|
            expect(variant_params_mapped.include?([charac[:name], charac[:type]])).to eq(true)
          end
        end
      end

      context "when the user is citizen who shared the variant product" do
        it 'should return 200 HTTP status code with the updated variant' do
          user_citizen = create(:citizen_user, email: "citizen3@ecity.fr")
          reference = create(:reference)
          product = reference.product
          user_citizen.citizen.products << product
          user_citizen.citizen.save
          request.headers["x-client-id"] = generate_token(user_citizen)
          uploaded_file = fixture_file_upload(Rails.root.join("spec/fixtures/files/images/harry-and-marv.jpg"), 'image/jpeg')

          variant_params = {
            basePrice: 19.9,
            weight: 0.24,
            quantity: 4,
            isDefault: true,
            goodDeal: {
              startAt: "17/05/2021",
              endAt: "18/06/2021",
              discount: 20,
            },
            characteristics: [
              {
                value: "coloris black",
                name: "color",
              },
              {
                value: "S",
                name: "size",
              },
            ],
          }
          patch :update, params: variant_params.merge(id:  reference.id, file: uploaded_file)
          should respond_with(200)
          result = JSON.parse(response.body, symbolize_names: true)
          expect(result[:basePrice]).to eq(variant_params[:basePrice])
          expect(result[:weight]).to eq(variant_params[:weight])
          expect(result[:quantity]).to eq(variant_params[:quantity])
          expect(result[:isDefault]).to eq(variant_params[:isDefault])
          expect(result[:goodDeal]).to eq(variant_params[:goodDeal])
          expect(reference.sample.images).to_not be_nil
          variant_params_mapped = variant_params[:characteristics].map { |c| [ c[:value], c[:name] ] }
          result[:characteristics].each do |charac|
            expect(variant_params_mapped.include?([charac[:name], charac[:type]])).to eq(true)
          end
        end
      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          patch :update, params: { id: 33 }
          expect(response).to have_http_status(401)
        end
      end

      context "User is admin" do
        before(:each) do
          @admin_user = create(:admin_user)
        end
        it "should return 403" do
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(@admin_user)
          reference = create(:reference)
          patch :update, params: {id: reference.id}
          expect(response).to have_http_status(403)
        end
      end

      context "User is not the owner of shop" do
        it "Should return 403 HTTP Status" do
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee536@ecity.fr')
          reference = create(:reference)
          @shop = reference.shop
          request.headers["HTTP_X_CLIENT_ID"] = generate_token(shop_employee_user)
          patch :update, params: variant_params.merge(id:  reference.id)

          expect(response).to have_http_status(403)
        end
      end

      context "when the user is citizen who not share the product" do
        it 'should return 403' do
          user_citizen = create(:citizen_user, email: "citizen3@ecity.fr")
          reference = create(:reference)
          request.headers["x-client-id"] = generate_token(user_citizen)

          patch :update, params: variant_params.merge(id:  reference.id)
          should respond_with(403)
        end
      end
    end
  end
end

def variant_params
  {
    basePrice: 19.9,
    weight: 0.24,
    quantity: 4,
    isDefault: true,
    goodDeal: {
      startAt: "17/05/2021",
      endAt: "18/06/2021",
      discount: 20.0,
    },
    characteristics: [
      {
        value: "coloris black",
        name: "color",
      },
      {
        value: "S",
        name: "size",
      },
    ],
  }
end
