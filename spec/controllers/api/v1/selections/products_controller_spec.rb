require "rails_helper"

RSpec.describe Api::V1::Selections::ProductsController, type: :controller do
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
      it "should return 200 HTTP Status and products selection without the product" do
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