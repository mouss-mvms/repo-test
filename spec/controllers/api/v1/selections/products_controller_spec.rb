require 'rails_helper'

RSpec.describe Api::V1::Selections::ProductsController do
  describe "GET #index" do
    context "All ok" do
      it "should return 200 HTTP status with a selection dto and all of its products" do
        selection = create(:online_selection)

        get :index, params: { id: selection.id }
        should respond_with(200)
        expect(response.body).to eq(
          {
            selection: Dto::V1::Selection::Response.create(selection).to_h,
            products: selection.products.map { |p| Dto::V1::Product::Response.create(p).to_h }
          }.to_json
        )
      end
    end

    context 'Bad params' do
      context "Selection does not exist" do
        it "should return 404 HTTP status" do
          get :index, params: { id: 666 }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Selection with 'id'=666").to_h.to_json)
        end
      end

      context "selection is not online" do
        it "should return a 403 HTTP status" do
          selection = create(:selection)
          get :index, params: { id: selection.id }
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end

  describe "POST #create" do
    context "All ok" do
      it "should return 200 HTTP Status and add product to products selection" do
        selection = create(:selection)
        product = create(:available_product)
        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)
        post :add, params: { selection_id: selection.id, id: product.id }
        should respond_with(200)
        expect(selection.reload.products).to include(product)
      end
    end

    context "Bad authentication" do
      context "x-client-id is missing" do
        it "should return 401 HTTP status" do
          selection = create(:selection)
          product = create(:available_product)
          post :add, params: { selection_id: selection.id, id: product.id }
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "User is not an admin" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          selection = create(:selection)
          product = create(:available_product)
          post :add, params: { selection_id: selection.id, id: product.id }
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end

    context "Product already in selection" do
      it "should return 422 HTTP Status" do
        product = create(:available_product)
        selection = create(:selection, products: [product])
        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)
        expect(selection.reload.products.count).to eq(1)
        post :add, params: { selection_id: selection.id, id: product.id }
        expect(response.body).to eq(Dto::Errors::UnprocessableEntity.new("Product already in selection.").to_h.to_json)
        expect(selection.reload.products.count).to eq(1)
      end
    end
  end

  describe "DELETE #destroy" do
    context "All ok" do
      it "should return 200 HTTP Status and products selection without the product" do
        product = create(:available_product)
        selection = create(:selection, products: [product])
        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)
        expect(selection.reload.products).to include(product)
        delete :remove, params: { selection_id: selection.id, id: product.id }
        should respond_with(200)
        expect(selection.reload.products).to_not include(product)
      end
    end

    context "Bad authentication" do
      context "x-client-id is missing" do
        it "should return 401 HTTP status" do
          selection = create(:selection)
          product = create(:available_product)
          delete :remove, params: { selection_id: selection.id, id: product.id }

          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "User is not an admin" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          selection = create(:selection)
          product = create(:available_product)
          delete :remove, params: { selection_id: selection.id, id: product.id }
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end
end
