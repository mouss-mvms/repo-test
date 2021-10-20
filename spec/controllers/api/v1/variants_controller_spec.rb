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
          request.env["CONTENT_TYPE"] = "multipart/form-data"
          uploaded_file = fixture_file_upload(Rails.root.join("spec/fixtures/files/images/harry-and-marv.jpg"), 'image/jpeg')
          body = { id: reference.id, files: [uploaded_file],
                   basePrice: 19.9,
                   weight: 0.24,
                   quantity: 4,
                   isDefault: true,
                   goodDeal: {
                     startAt: "17/05/2021",
                     endAt: "18/06/2021",
                     discount: 20.0,
                   }.to_json,
                   characteristics: [
                     {
                       value: "coloris black",
                       name: "color",
                     },
                     {
                       value: "S",
                       name: "size",
                     },
                   ].to_json
          }

          patch :update, params: body
          should respond_with(200)
          result = JSON.parse(response.body, symbolize_names: true)
          expect(result[:basePrice]).to eq(variant_params[:basePrice])
          expect(result[:weight]).to eq(variant_params[:weight])
          expect(result[:quantity]).to eq(variant_params[:quantity])
          expect(result[:isDefault]).to eq(variant_params[:isDefault])
          expect(result[:goodDeal]).to eq(JSON.parse(variant_params[:goodDeal], symbolize_names: true))
          expect(result[:imageUrls]).to_not be_nil
          hash_variant_params = variant_params[:characteristics].map { |c| JSON.parse(c, symbolize_names: true) }
          variant_params_mapped = hash_variant_params.map { |c| [c[:value], c[:name]] }
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
          request.headers["CONTENT_TYPE"] = 'application/x-www-form-urlencoded'
          request.env["CONTENT_TYPE"] = "multipart/form-data"
          uploaded_file = fixture_file_upload(Rails.root.join("spec/fixtures/files/images/harry-and-marv.jpg"), 'image/jpeg')
          body = { id: reference.id, files: [uploaded_file],
                   basePrice: 19.9,
                   weight: 0.24,
                   quantity: 4,
                   isDefault: true,
                   goodDeal: {
                     startAt: "17/05/2021",
                     endAt: "18/06/2021",
                     discount: 20.0,
                   }.to_json,
                   characteristics: [
                     {
                       value: "coloris black",
                       name: "color",
                     },
                     {
                       value: "S",
                       name: "size",
                     },
                   ].to_json
          }

          patch :update, params: body
          should respond_with(200)
          result = JSON.parse(response.body, symbolize_names: true)
          expect(result[:basePrice]).to eq(variant_params[:basePrice])
          expect(result[:weight]).to eq(variant_params[:weight])
          expect(result[:quantity]).to eq(variant_params[:quantity])
          expect(result[:isDefault]).to eq(variant_params[:isDefault])
          expect(result[:goodDeal]).to eq(JSON.parse(variant_params[:goodDeal], symbolize_names: true))
          expect(result[:imageUrls]).to_not be_nil
          hash_variant_params = variant_params[:characteristics].map { |c| JSON.parse(c, symbolize_names: true) }
          variant_params_mapped = hash_variant_params.map { |c| [c[:value], c[:name]] }
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
          patch :update, params: { id: reference.id }
          expect(response).to have_http_status(403)
        end
      end

      context "User is not the owner of shop" do
        it "Should return 403 HTTP Status" do
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee536@ecity.fr')
          reference = create(:reference)
          @shop = reference.shop
          request.headers["HTTP_X_CLIENT_ID"] = generate_token(shop_employee_user)
          patch :update, params: variant_params.merge(id: reference.id)

          expect(response).to have_http_status(403)
        end
      end

      context "when the user is citizen who not share the product" do
        it 'should return 403' do
          user_citizen = create(:citizen_user, email: "citizen3@ecity.fr")
          reference = create(:reference)
          request.headers["x-client-id"] = generate_token(user_citizen)

          patch :update, params: variant_params.merge(id: reference.id)
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
    }.to_json,
    characteristics: [
      {
        value: "coloris black",
        name: "color",
      }.to_json,
      {
        value: "S",
        name: "size",
      }.to_json,
    ],
  }
end
