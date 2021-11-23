require 'rails_helper'

RSpec.describe Api::V1::SelectionsController, type: :controller do
  describe "POST #create" do
    context "All ok" do
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
        expect(response_body[:tagIds].map {|tag| tag[:id]}).to eq(@create_params[:tagIds])
        expect(response_body[:startAt]).to_not be_empty
        expect(response_body[:endAt]).to_not be_empty
        expect(response_body[:homePage]).to eq(@create_params[:homePage])
        expect(response_body[:event]).to eq(@create_params[:event])
        expect(response_body[:state]).to eq(@create_params[:state])
        expect(response_body[:imageUrl]).to_not be_empty
      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          post :create
          expect(response).to have_http_status(401)
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

          expect(response).to have_http_status(400)
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

          expect(response).to have_http_status(400)
        end
      end

      context 'image_url is missing' do
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

          expect(response).to have_http_status(400)
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
          post :create, params: @create_params

          expect(response).to have_http_status(404)
        end
      end
    end

    context 'when status is incorrect' do
      it 'should return 2200 HTTP status ' do
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

        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PATCH #patch" do
    context "All ok" do
      it 'should return 201 HTTP status code with selection object' do
        selection = create(:selection)
        tag1 = create(:tag)
        tag2 = create(:tag)
        tag3 = create(:tag)
        @update_params = {
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

        admin_user = create(:admin_user)
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(admin_user)

        post :patch, params: @update_params.merge(id: selection.id)

        expect(response).to have_http_status(201)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:name]).to eq(@update_params[:name])
        expect(response_body[:description]).to eq(@update_params[:description])
        expect(response_body[:tagIds].map {|tag| tag[:id]}).to eq(@update_params[:tagIds])
        expect(response_body[:startAt]).to_not be_empty
        expect(response_body[:endAt]).to_not be_empty
        expect(response_body[:homePage]).to eq(@update_params[:homePage])
        expect(response_body[:event]).to eq(@update_params[:event])
        expect(response_body[:state]).to eq(@update_params[:state])
        expect(response_body[:imageUrl]).to_not be_empty
      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          post :create
          expect(response).to have_http_status(401)
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

      context 'Selection not found' do
        it "should return 404 HTTP status" do
          @update_params = {
            tagIds: [15]
          }
          post :patch, params: @update_params.merge(id: 198987987879)

          expect(response).to have_http_status(404)
        end
      end

      context 'Tags not found' do
        it "should return 404 HTTP status" do
          selection = create(:selection)
          @update_params = {
            tagIds: [15]
          }
          post :patch, params: @update_params.merge(id: selection.id)

          expect(response).to have_http_status(404)
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

        expect(response).to have_http_status(422)
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
        expect(Selection.where(id: selection.id).first).to be_nil
      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          selection = create(:selection)
          delete :destroy, params: { id: selection.id }
          expect(response).to have_http_status(401)
        end
      end

      context "User is not an admin" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          selection = create(:selection)
          delete :destroy, params: { id: selection.id }
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
