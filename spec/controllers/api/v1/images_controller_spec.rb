require 'rails_helper'

RSpec.describe Api::V1::ImagesController, type: :controller do
  describe "POST #create" do
    context "All ok" do
      it 'should return 201 HTTP status with image urls' do
        user = create(:user)
        request.headers["x-client-id"] = generate_token(user)
        request.env["CONTENT_TYPE"] = "multipart/form-data"
        uploaded_files = []
        5.times do
          uploaded_files << fixture_file_upload(Rails.root.join("spec/fixtures/files/images/harry-and-marv.jpg"), 'image/jpeg')
        end

        post :create, params: { files: uploaded_files }
        should respond_with(201)
        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq(5)
        expect do
          response_body.each do |item|
            uri = URI.parse(item)
            %w( http https ).include?(uri.scheme)
          end
        end
      end
    end

    context "Bad Params" do
      context "Files are not photo" do
        it "should return 400 HTTP status" do
          user = create(:user)
          request.headers["x-client-id"] = generate_token(user)
          request.env["CONTENT_TYPE"] = "multipart/form-data"

          post :create, params: { files: ['chuck', 3423] }
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('Incorrect File Format').to_h.to_json)
        end
      end
    end

    context "Bad authentication" do
      context "X-client-id is missing" do
        it  "should return 401 HTTP status" do
          request.env["CONTENT_TYPE"] = "multipart/form-data"
          uploaded_file = fixture_file_upload(Rails.root.join("spec/fixtures/files/images/harry-and-marv.jpg"), 'image/jpeg')

          post :create, params: { files: [uploaded_file] }
          should respond_with(401)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "User does not exist" do
        it "should return 403 HTTP status" do
          user = create(:user)
          request.headers["x-client-id"] = generate_token(user)
          request.env["CONTENT_TYPE"] = "multipart/form-data"
          uploaded_file = fixture_file_upload(Rails.root.join("spec/fixtures/files/images/harry-and-marv.jpg"), 'image/jpeg')
          User.destroy_all

          post :create, params: { files: [uploaded_file] }
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end
end
