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
          slug: "selection-test",
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
        expect(response_body[:slug]).to eq(@create_params[:slug])
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
            slug: "selection-test",
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

      context 'slug is missing' do
        it "should return 400 HTTP status" do
          @create_params = {
            name: "oui",
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
            slug: "oui",
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
            slug: "oui",
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
            slug: "oui",
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
          slug: "selection-test",
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
end
