require 'rails_helper'

RSpec.describe Api::V1::Products::VariantsController, type: :controller do
  describe 'DELETE #destroy' do
    context 'All ok' do
      it 'should return 204 HTTP status' do
        shop = create(:shop)
        product = create(:product)
        ref1 = create(:reference)
        product.references << ref1
        ref2 = create(:reference)
        product.references << ref2
        product.save
        shop.products << product

        user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
        user_shop_employee.shop_employee.shops << shop
        user_shop_employee.shop_employee.save

        shop.owner = user_shop_employee.shop_employee
        shop.save

        request.headers["x-client-id"] = generate_token(user_shop_employee)

        delete :destroy, params: {product_id: product.id, id: ref1.id}

        expect(response).to have_http_status(:no_content)
        expect(Reference.where(id: ref1.id).any?).to be_falsey
      end
    end

    context 'Bad authentication' do
      context "x-client-id is missing" do
        it "should return 401 HTTP status" do
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save

          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context 'User is not a shop employee' do
        it 'should return 403 HTTP status' do
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save

          user_citizen = create(:citizen_user, email: "citizen678987@ecity.fr")
          request.headers["x-client-id"] = generate_token(user_citizen)

          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end


      context "User is shop employee but not the owner of shop which send the product" do
        it 'should return 403 HTTP status' do
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save

          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          request.headers["x-client-id"] = generate_token(user_shop_employee)

          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)

        end
      end
    end

    context 'Bad params' do
      context "Product doesn't find" do
        it 'should return 404 HTTP Status' do
          shop = create(:shop)
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save
          shop.products << product

          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save

          shop.owner = user_shop_employee.shop_employee
          shop.save

          request.headers["x-client-id"] = generate_token(user_shop_employee)
          Product.destroy_all
          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{product.id}").to_h.to_json)
        end
      end

      context "Reference doesn't exist for the product" do
        it 'should return 404 HTTP Status' do
          shop = create(:shop)
          product = create(:product)
          ref1 = create(:reference)
          ref2 = create(:reference)
          product.references << ref2
          product.save
          shop.products << product

          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save

          shop.owner = user_shop_employee.shop_employee
          shop.save

          request.headers["x-client-id"] = generate_token(user_shop_employee)

          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Reference with 'id'=#{ref1.id} [WHERE \"pr_references\".\"product_id\" = $1]").to_h.to_json)
        end
      end
    end
  end
end

