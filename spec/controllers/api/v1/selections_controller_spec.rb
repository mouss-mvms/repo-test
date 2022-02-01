require 'rails_helper'

RSpec.describe Api::V1::SelectionsController, type: :controller do

  describe "GET #index" do
    context "All ok" do
      before(:each) do
        Selection.destroy_all
      end
      context "No page params" do
        it "should return 200 HTTP status" do
          count = 16
          create_list(:online_selection, count)

          get :index
          should respond_with(200)
          result = JSON.parse(response.body).deep_symbolize_keys
          expect(result[:selections].count).to eq(count)
          result[:selections].each do |result_selection|
            expect_selection = Selection.find(result_selection[:id])
            expect(result_selection).to eq(Dto::V1::Selection::Response.create(expect_selection).to_h)
          end
        end
      end
    end
  end

  describe "GET #show" do
    context "All ok" do
      it "should return 200 HTTP status and a selection dto" do
        selection = create(:online_selection)

        get :show, params: { id: selection.id }
        should respond_with(200)
        expect(response.body).to eq(Dto::V1::Selection::Response.create(selection).to_h.to_json)
      end
    end

    context 'Bad params' do
      context "Selection does not exist" do
        it "should return 404 HTTP status" do
          get :show, params: { id: 666 }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Selection with 'id'=666").to_h.to_json)
        end
      end

      context "selection is not online" do
        it "should return a 403 HTTP status" do
          selection = create(:selection)
          get :show, params: { id: selection.id }
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end

  describe "POST #create" do
    context "All ok" do
      context "when imageUrl" do
        it 'should return 201 HTTP status code with selection object' do
          tag1 = create(:tag)
          tag2 = create(:tag)
          tag3 = create(:tag)
          @create_params = {
            name: "Selection Test",
            description: "Ceci est discription test.",
            tagIds: [tag1.id, tag2.id, tag3.id],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active",
            imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          }

          admin_user = create(:admin_user)
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)

          post :create, params: @create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(@create_params[:name])
          expect(response_body[:description]).to eq(@create_params[:description])
          expect(response_body[:tagIds]).to eq(@create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(@create_params[:homePage])
          expect(response_body[:event]).to eq(@create_params[:event])
          expect(response_body[:state]).to eq(@create_params[:state])
          expect(response_body[:imageUrl]).to_not be_empty
        end
      end

      context "when imageId" do
        it 'should return 201 HTTP status code with selection object' do
          image = create(:image)
          tag1 = create(:tag)
          tag2 = create(:tag)
          tag3 = create(:tag)
          @create_params = {
            name: "Selection Test",
            description: "Ceci est discription test.",
            tagIds: [tag1.id, tag2.id, tag3.id],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active",
            imageId: image.id
          }

          admin_user = create(:admin_user)
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)

          post :create, params: @create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(@create_params[:name])
          expect(response_body[:description]).to eq(@create_params[:description])
          expect(response_body[:tagIds]).to eq(@create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(@create_params[:homePage])
          expect(response_body[:event]).to eq(@create_params[:event])
          expect(response_body[:state]).to eq(@create_params[:state])
          expect(response_body[:imageUrl]).to_not be_empty
          expect(response_body[:imageUrl]).to eq(image.file_url)
        end
      end

      context "when imageId and imageUrl are both sent" do
        it "should return 201 HTTP status code with selection object with only imageId" do
          image = create(:image)
          tag1 = create(:tag)
          tag2 = create(:tag)
          tag3 = create(:tag)
          @create_params = {
            name: "Selection Test",
            description: "Ceci est discription test.",
            tagIds: [tag1.id, tag2.id, tag3.id],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active",
            imageId: image.id,
            imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          }

          admin_user = create(:admin_user)
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)

          post :create, params: @create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(@create_params[:name])
          expect(response_body[:description]).to eq(@create_params[:description])
          expect(response_body[:tagIds]).to eq(@create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(@create_params[:homePage])
          expect(response_body[:event]).to eq(@create_params[:event])
          expect(response_body[:state]).to eq(@create_params[:state])
          expect(response_body[:imageUrl]).to_not be_empty
          expect(response_body[:imageUrl]).to eq(image.file_url)
        end
      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          post :create
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "User is not an admin" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          post :create
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end

    context 'Bad Params' do
      before(:each) do
        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)
      end

      context 'name is missing' do
        it "should return 400 HTTP status" do
          @create_params = {
            description: "Ceci est discription test.",
            tagIds: [],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active",
            imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          }
          post :create, params: @create_params

          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: name").to_h.to_json)
        end
      end

      context 'description is missing' do
        it "should return 400 HTTP status" do
          @create_params = {
            name: "oui",
            tagIds: [],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active",
            imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          }
          post :create, params: @create_params

          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: description").to_h.to_json)
        end
      end

      context 'image_url and image_id are missing' do
        it "should return 400 HTTP status" do
          @create_params = {
            name: "oui",
            description: "oui oui oui",
            tagIds: [],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active"
          }
          post :create, params: @create_params

          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: imageId or imageUrl").to_h.to_json)
        end
      end

      context 'Tags not found' do
        it "should return 404 HTTP status" do
          @create_params = {
            name: "oui",
            description: "oui oui oui",
            tagIds: [15],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg",
            state: "active"
          }
          Selection.destroy_all
          post :create, params: @create_params
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Tag with 'id'=15").to_h.to_json)
          expect(Selection.all.count).to eq(0)
        end
      end
    end

    context 'when status is incorrect' do
      it 'should return 422 HTTP status ' do
        tag1 = create(:tag)
        tag2 = create(:tag)
        tag3 = create(:tag)
        @create_params = {
          name: "Selection Test",
          description: "Ceci est discription test.",
          tagIds: [tag1.id, tag2.id, tag3.id],
          startAt: "17/05/2021",
          endAt: "18/06/2021",
          homePage: true,
          event: true,
          state: "dada",
          imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
        }

        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)

        post :create, params: @create_params

        expect(response.body).to eq(Dto::Errors::UnprocessableEntity.new("'dada' is not a valid state").to_h.to_json)
      end
    end
  end

  describe "PATCH #patch" do
    context "All ok" do
      before(:each) do
        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)
      end

      context "with image_urls" do
        it 'should return 200 HTTP status code with selection object' do
          selection = create(:selection)
          tag1 = create(:tag)
          tag2 = create(:tag)
          tag3 = create(:tag)
          update_params = {
            name: "Selectiofaan Test",
            description: "Ceci est description test.",
            tagIds: [tag1.id, tag2.id, tag3.id],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active",
            imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          }

          post :patch, params: update_params.merge(id: selection.id)

          expect(response).to have_http_status(200)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(update_params[:name])
          expect(response_body[:description]).to eq(update_params[:description])
          expect(response_body[:tagIds]).to eq(update_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(update_params[:homePage])
          expect(response_body[:event]).to eq(update_params[:event])
          expect(response_body[:state]).to eq(update_params[:state])
          expect(response_body[:imageUrl]).to_not be_empty
        end
      end

      context "with image_ids" do
        it 'should return 200 HTTP status code with selection object' do
          image = create(:image)
          selection = create(:selection)
          tag1 = create(:tag)
          tag2 = create(:tag)
          tag3 = create(:tag)
          update_params = {
            name: "Selectiofaan Test",
            description: "Ceci est description test.",
            tagIds: [tag1.id, tag2.id, tag3.id],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active",
            imageId: image.id
          }

          post :patch, params: update_params.merge(id: selection.id)

          expect(response).to have_http_status(200)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(update_params[:name])
          expect(response_body[:description]).to eq(update_params[:description])
          expect(response_body[:tagIds]).to eq(update_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(update_params[:homePage])
          expect(response_body[:event]).to eq(update_params[:event])
          expect(response_body[:state]).to eq(update_params[:state])
          expect(response_body[:imageUrl]).to_not be_empty
          expect(response_body[:imageUrl]).to eq(image.file_url)
        end
      end

      context "imageIds and imagUrls are both sent" do
        it "should return 200 HTTP status code with selection object" do
          selection = create(:selection)
          image = create(:image)
          tag1 = create(:tag)
          tag2 = create(:tag)
          tag3 = create(:tag)
          update_params = {
            name: "Selectiofaan Test",
            description: "Ceci est description test.",
            tagIds: [tag1.id, tag2.id, tag3.id],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            state: "active",
            imageId: image.id,
            imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          }

          post :patch, params: update_params.merge(id: selection.id)

          expect(response).to have_http_status(200)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(update_params[:name])
          expect(response_body[:description]).to eq(update_params[:description])
          expect(response_body[:tagIds]).to eq(update_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(update_params[:homePage])
          expect(response_body[:event]).to eq(update_params[:event])
          expect(response_body[:state]).to eq(update_params[:state])
          expect(response_body[:imageUrl]).to_not be_empty
          expect(response_body[:imageUrl]).to eq(image.file_url)
        end
      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          post :create
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "User is not an admin" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          post :create
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'Bad Params' do
      before(:each) do
        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)
      end

      context "image not found" do
        it "should return 404 HTTP status" do
          wrong_id = 0
          selection = create(:selection)
          update_params = {
            imageId: wrong_id
          }

          post :patch, params: update_params.merge(id: selection.id)
          expect(response).to have_http_status(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Image with 'id'=#{wrong_id}").to_h.to_json)
        end
      end

      context 'Selection not found' do
        it "should return 404 HTTP status" do
          update_params = {
            tagIds: [15]
          }
          Selection.destroy_all
          post :patch, params: update_params.merge(id: 1978)

          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Selection with 'id'=1978").to_h.to_json)
        end
      end

      context 'Tags not found' do
        it "should return 404 HTTP status" do
          selection = create(:selection)
          update_params = {
            tagIds: [15]
          }
          post :patch, params: update_params.merge(id: selection.id)

          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Tag with 'id'=15").to_h.to_json)
        end
      end
    end

    context 'when status is incorrect' do
      it 'should return 422 HTTP status ' do
        tag1 = create(:tag)
        tag2 = create(:tag)
        tag3 = create(:tag)
        @create_params = {
          name: "Selection Test",
          description: "Ceci est discription test.",
          tagIds: [tag1.id, tag2.id, tag3.id],
          startAt: "17/05/2021",
          endAt: "18/06/2021",
          homePage: true,
          event: true,
          state: "dada",
          imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
        }

        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)

        post :create, params: @create_params

        expect(response.body).to eq(Dto::Errors::UnprocessableEntity.new("'dada' is not a valid state").to_h.to_json)
      end
    end
  end

  describe "DELETE #destroy" do
    context "All ok" do
      it 'should return 204 HTTP status' do
        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)
        selection = create(:selection)
        delete :destroy, params: { id: selection.id }
        expect(response).to have_http_status(204)
        expect(Selection.exists?(selection.id)).to be_falsey
      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          selection = create(:selection)
          delete :destroy, params: { id: selection.id }
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "User is not an admin" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          selection = create(:selection)
          delete :destroy, params: { id: selection.id }
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end
end
