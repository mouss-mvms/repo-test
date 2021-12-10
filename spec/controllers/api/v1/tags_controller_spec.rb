require 'rails_helper'

RSpec.describe Api::V1::TagsController, type: :controller do
  describe "GET #index" do
    context "All ok" do
      it 'should return 200 HTTP Status with list of tags' do
        count = 5
        count.times do
          create(:tag)
        end

        get :index

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body).deep_symbolize_keys
        expect(result[:tags].count).to eq(count)
        result[:tags].each do |result_tag|
          expect_tag = Tag.find(result_tag[:id])
          expect(result_tag).to eq(Dto::V1::Tag::Response.create(expect_tag).to_h)
        end
      end
    end
  end

  describe "GET #show" do
    context "All ok" do
      it 'should return 200 HTTP Status with tag' do
        tag = create(:tag)

        get :show, params: {id: tag.id}

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body).deep_symbolize_keys
        expect(result).to eq(Dto::V1::Tag::Response.create(tag).to_h)
      end
    end

    context "Tag not found" do
      it 'should return 404 HTTP Status' do
        tag = create(:tag)
        Tag.destroy_all

        get :show, params: {id: tag.id}

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Tag with 'id'=#{tag.id}").to_h.to_json)
      end
    end
  end

end
