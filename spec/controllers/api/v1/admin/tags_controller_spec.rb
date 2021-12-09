require 'rails_helper'

RSpec.describe Api::V1::Admin::TagsController do
  describe "All ok" do
    it "should create a Tag with 201 HTTP status" do
      user = create(:admin_user)
      request.headers['x-client-id'] = generate_token(user)
      create_params = {
        name: 'Chuck',
        status: 'active',
        featured: true,
        imageUrl: 'https://path/to/image.jpg'
      }
      Tag.destroy_all
      expect(Tag.count).to eq(0)

      post :create, params: create_params
      should respond_with(201)
      expect(Tag.count).to eq(1)
      expect(response.body).to eq(Dto::V1::Tag::Response.create(Tag.first).to_h.to_json)
    end
  end

  describe "Bad params" do
    let(:user) { create(:admin_user) }
    context "no name" do
      it "should return 400 HTTP status" do
        request.headers['x-client-id'] = generate_token(user)
        create_params = {
          status: "not_active",
          featured: false,
          image_url: "https://path/to/image.jpg"
        }

        post :create, params: create_params
        should respond_with(400)
        expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: name').to_h.to_json)
      end
    end

    context "no status" do
      it "should return 400 HTTP status" do
        request.headers['x-client-id'] = generate_token(user)
        create_params = {
          name: "Chuck Noris",
          featured: false,
          image_url: "https://path/to/image.jpg"
        }

        post :create, params: create_params
        should respond_with(400)
        expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: status').to_h.to_json)
      end
    end
  end

  describe "Bad Authentication" do
    context "no x-client-id" do
      it "should return 401 HTTP status" do
        post :create, params: { id: 44 }
        should respond_with(401)
        expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
      end
    end

    context "user doesn't exist" do
      it "should return 403 HTTP status" do
        user = create(:user)
        request.headers['x-client-id'] = generate_token(user)
        User.destroy_all

        post :create, params: { id: 44 }
        should respond_with(403)
        expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
      end
    end

    context "user is not an admin" do
      it "should return 403 HTTP status" do
        user = create(:user)
        request.headers['x-client-id'] = generate_token(user)

        post :create, params: { id: 44 }
        should respond_with(403)
        expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
      end
    end
  end
end
