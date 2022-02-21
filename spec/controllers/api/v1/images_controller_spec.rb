require 'rails_helper'

RSpec.describe Api::V1::ImagesController, type: :controller do
  describe "POST #create" do
    context "All ok" do
      it 'should return 201 HTTP status with image urls' do
        user = create(:user)
        request.headers["x-client-id"] = generate_token(user)
        request.env["CONTENT_TYPE"] = "multipart/form-data"
        uploaded_files = []
        2.times do
          uploaded_files << fixture_file_upload(Rails.root.join("spec/fixtures/files/images/harry-and-marv.jpg"), 'image/jpeg')
        end
        Image.destroy_all

        post :create, params: { files: uploaded_files }
        should respond_with(201)
        expect(response.body).to eq(
          Image.all.map do |image|
            Dto::V1::Image::Response.create(image).to_h
          end.to_json
        )
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

  describe "DELETE #destroy" do
    describe "All is ok" do
      it "returns 204 HTTP status" do
        user = create(:citizen_user)
        citizen_image = create(:image)
        user.citizen.update(image_id: citizen_image.id)

        request.headers['x-client-id'] = generate_token(user)

        delete :destroy_avatar, params: { id: citizen_image.id }
        expect(response).to have_http_status(204)
        expect(user.citizen.reload.image).to be_nil
      end
    end

    describe "Bad params" do
      context "When image doesn't belong to citizen" do
        it "returns 403 HTTP status" do
          user = create(:citizen_user)
          citizen_image = create(:image)
          user.citizen.update(image_id: citizen_image.id)

          wrong_image = create(:image)
          request.headers['x-client-id'] = generate_token(user)

          delete :destroy_avatar, params: { id: wrong_image.id }
          expect(response).to have_http_status(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)

          user.citizen.image.destroy
          user.destroy
          wrong_image.destroy
        end
      end
    end

    describe "Bad authentication" do
      context "When no x-client-id" do
        it "returns 401 HTTP status" do
          delete :destroy_avatar, params: { id: 0 }
          expect(response).to have_http_status(401)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "When user is not a citizen" do
        it "returns 403 HTTP status" do
          image = create(:image)
          wrong_users = [create(:admin_user), create(:shop_employee_user), create(:user)]

          wrong_users.each do |wrong_user|
            request.headers['x-client-id'] = generate_token(wrong_user)
            delete :destroy_avatar, params: { id: image.id }
            expect(response).to have_http_status(403)
            expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          end

          image.destroy
          wrong_users.each(&:destroy)
        end
      end
    end
  end
end
