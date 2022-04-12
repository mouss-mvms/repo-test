require 'rails_helper'

RSpec.describe Api::V1::SelectionsController, type: :controller do

  describe "GET #index" do
    context "All ok" do
      before(:all) do
        @count = 16
        create_list(:online_selection, @count)
      end

      after(:all) do
        @count = nil
        Selection.destroy_all
      end

      context "No page params" do
        it "should return 200 HTTP status" do
          get :index
          should respond_with(200)
          result = JSON.parse(response.body).deep_symbolize_keys
          expect(result[:selections].count).to eq(@count)
          result[:selections].each do |result_selection|
            expect_selection = Selection.find(result_selection[:id])
            expect(result_selection).to eq(Dto::V1::Selection::Response.create(expect_selection).to_h)
          end
        end
      end

      context "when params promoted is true" do
        it "should return HTTP status 200 with only promoted selections" do
          get :index, params: { promoted: "true" }
          should respond_with(200)
          result = JSON.parse(response.body).deep_symbolize_keys
          result[:selections].each do |result_selection|
            expect_selection = Selection.find(result_selection[:id])
            expect(expect_selection.featured).to be_truthy
            expect(result_selection).to eq(Dto::V1::Selection::Response.create(expect_selection).to_h)
          end
        end
      end

      context "when slug params is present" do
        it "should return HTTP status 200 with only promoted selections" do
          selection = create(:online_selection)
          get :index, params: { slug: selection.slug }
          should respond_with(200)
          result = JSON.parse(response.body).deep_symbolize_keys
          result[:selections].each do |result_selection|
            expect_selection = Selection.find(result_selection[:id])
            expect(expect_selection.slug).to eq(selection.slug)
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
      before :all do
        @tag1 = create(:tag)
        @tag2 = create(:tag)
        @tag3 = create(:tag)
        @params = {
          name: "Selection Test",
          description: "Ceci est discription test.",
          tagIds: [@tag1.id, @tag2.id, @tag3.id],
          startAt: "17/05/2021",
          endAt: "18/06/2021",
          homePage: true,
          event: true,
          state: "active",
          long_description: "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?
          Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?
          Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit."
        }
        @admin = create(:admin_user)
        @admin_token = generate_token(@admin)
        @image = create(:image)
        @cover = create(:image)
      end

      after :all do
        Selection.destroy_all
        @tag1.destroy
        @tag2.destroy
        @tag3.destroy
        @image.destroy
        @cover.destroy
        @params = nil
        @admin.destroy
        @admin_token = nil
      end

      context "when imageUrl" do
        it 'should return 201 HTTP status code with selection object' do
          create_params = @params.clone
          create_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"

          request.headers['HTTP_X_CLIENT_ID'] = @admin_token

          post :create, params: create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(create_params[:name])
          expect(response_body[:description]).to eq(create_params[:description])
          expect(response_body[:tagIds]).to eq(create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(create_params[:homePage])
          expect(response_body[:event]).to eq(create_params[:event])
          expect(response_body[:state]).to eq(create_params[:state])
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:cover]).to be_empty
          expect(response_body[:promoted]).to be_falsey
          expect(response_body[:longDescription]).to eq(create_params[:longDescription])
        end
      end

      context "when imageId" do
        it 'should return 201 HTTP status code with selection object' do
          create_params = @params.clone
          create_params[:imageId] = @image.id

          request.headers['HTTP_X_CLIENT_ID'] = @admin_token
          post :create, params: create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(create_params[:name])
          expect(response_body[:description]).to eq(create_params[:description])
          expect(response_body[:tagIds]).to eq(create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(create_params[:homePage])
          expect(response_body[:event]).to eq(create_params[:event])
          expect(response_body[:state]).to eq(create_params[:state])
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:image][:originalUrl]).to eq(@image.file_url)
          expect(response_body[:image][:id]).to eq(create_params[:imageId])
          expect(response_body[:cover]).to be_empty
          expect(response_body[:promoted]).to be_falsey
          expect(response_body[:longDescription]).to eq(create_params[:longDescription])
        end
      end

      context "when imageId and imageUrl are both sent" do
        it "should return 201 HTTP status code with selection object with only imageId" do
          create_params = @params.clone
          create_params[:imageId] = @image.id
          create_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg",

            request.headers['HTTP_X_CLIENT_ID'] = @admin_token

          post :create, params: create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(create_params[:name])
          expect(response_body[:description]).to eq(create_params[:description])
          expect(response_body[:tagIds]).to eq(create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(create_params[:homePage])
          expect(response_body[:event]).to eq(create_params[:event])
          expect(response_body[:state]).to eq(create_params[:state])
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:image][:originalUrl]).to eq(@image.file_url)
          expect(response_body[:cover]).to be_empty
          expect(response_body[:promoted]).to be_falsey
          expect(response_body[:longDescription]).to eq(create_params[:longDescription])
        end
      end

      context "when coverUrl" do
        it 'should return 201 HTTP status code with selection object' do
          create_params = @params.clone
          create_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          create_params[:coverUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"

          request.headers['HTTP_X_CLIENT_ID'] = @admin_token

          post :create, params: create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(create_params[:name])
          expect(response_body[:description]).to eq(create_params[:description])
          expect(response_body[:tagIds]).to eq(create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(create_params[:homePage])
          expect(response_body[:event]).to eq(create_params[:event])
          expect(response_body[:state]).to eq(create_params[:state])
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:cover]).to_not be_empty
          expect(response_body[:promoted]).to be_falsey
          expect(response_body[:longDescription]).to eq(create_params[:longDescription])
        end
      end

      context "when coverId" do
        it 'should return 201 HTTP status code with selection object' do
          create_params = @params.clone
          create_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          create_params[:coverId] = @cover.id

          request.headers['HTTP_X_CLIENT_ID'] = @admin_token

          post :create, params: create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(create_params[:name])
          expect(response_body[:description]).to eq(create_params[:description])
          expect(response_body[:tagIds]).to eq(create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(create_params[:homePage])
          expect(response_body[:event]).to eq(create_params[:event])
          expect(response_body[:state]).to eq(create_params[:state])
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:cover]).to_not be_empty
          expect(response_body[:cover][:originalUrl]).to eq(@cover.file_url)
          expect(response_body[:cover][:id]).to eq(create_params[:coverId])
          expect(response_body[:promoted]).to be_falsey
          expect(response_body[:longDescription]).to eq(create_params[:longDescription])
        end
      end

      context "when coverId and coverUrl are both sent" do
        it "should return 201 HTTP status code with selection object with only coverId" do
          create_params = @params.clone
          create_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          create_params[:imageId] = @image.id
          create_params[:coverUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          create_params[:coverId] = @cover.id

          request.headers['HTTP_X_CLIENT_ID'] = @admin_token

          post :create, params: create_params

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:name]).to eq(create_params[:name])
          expect(response_body[:description]).to eq(create_params[:description])
          expect(response_body[:tagIds]).to eq(create_params[:tagIds])
          expect(response_body[:startAt]).to_not be_empty
          expect(response_body[:endAt]).to_not be_empty
          expect(response_body[:homePage]).to eq(create_params[:homePage])
          expect(response_body[:event]).to eq(create_params[:event])
          expect(response_body[:state]).to eq(create_params[:state])
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:image][:originalUrl]).to eq(@image.file_url)
          expect(response_body[:image][:id]).to eq(create_params[:imageId])
          expect(response_body[:cover]).to_not be_empty
          expect(response_body[:cover][:originalUrl]).to eq(@cover.file_url)
          expect(response_body[:cover][:id]).to eq(create_params[:coverId])
          expect(response_body[:promoted]).to be_falsey
          expect(response_body[:longDescription]).to eq(create_params[:longDescription])
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
          wrong_id = 0
          @create_params = {
            name: "oui",
            description: "oui oui oui",
            tagIds: [wrong_id],
            startAt: "17/05/2021",
            endAt: "18/06/2021",
            homePage: true,
            event: true,
            imageUrl: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg",
            state: "active"
          }
          Selection.destroy_all
          post :create, params: @create_params
          expect(response).to have_http_status(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Tag with 'id'=#{wrong_id}").to_h.to_json)
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
      before :all do
        @admin_user = create(:admin_user)
        @admin_token = generate_token(@admin_user)
        @tag1 = create(:tag)
        @tag2 = create(:tag)
        @tag3 = create(:tag)
        @params = {
          name: "Selection Test",
          description: "Ceci est discription test.",
          tagIds: [@tag1.id, @tag2.id, @tag3.id],
          startAt: "17/05/2021",
          endAt: "18/06/2021",
          homePage: true,
          event: true,
          state: "active",
          long_description: "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?
          Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?
          Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit."
        }
        @image = create(:image)
        @cover = create(:image)
      end

      after :all do
        @admin_token = nil
        Selection.destroy_all
        @tag1.destroy
        @tag2.destroy
        @tag3.destroy
        @admin_user.destroy
      end

      context "with imageUrl" do
        it 'should return 200 HTTP status code with selection object' do
          selection = create(:selection)
          update_params = @params.clone
          update_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"

          request.headers['x-client-id'] = @admin_token
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
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:longDescription]).to eq(update_params[:longDescription])
        end
      end

      context "with imageId" do
        it 'should return 200 HTTP status code with selection object' do
          selection = create(:selection)
          update_params = @params.clone
          update_params[:imageId] = @image.id

          request.headers['x-client-id'] = @admin_token
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
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:image][:originalUrl]).to eq(@image.file_url)
          expect(response_body[:longDescription]).to eq(update_params[:longDescription])
        end
      end

      context "imageId and imagUrl are both sent" do
        it "should return 200 HTTP status code with selection object" do
          selection = create(:selection)
          update_params = @params.clone
          update_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          update_params[:imageId] = @image.id

          request.headers['x-client-id'] = @admin_token

          request.headers['x-client-id'] = @admin_token
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
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:image][:originalUrl]).to eq(@image.file_url)
          expect(response_body[:longDescription]).to eq(update_params[:longDescription])
        end
      end

      context "with coverUrl" do
        it 'should return 200 HTTP status code with selection object' do
          selection = create(:selection)
          update_params = @params.clone
          update_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          update_params[:coverUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          update_params[:promoted] = true

          request.headers['x-client-id'] = @admin_token
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
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:cover]).to_not be_empty
          expect(response_body[:longDescription]).to eq(update_params[:longDescription])
          expect(response_body[:promoted]).to eq(update_params[:promoted])
        end
      end

      context "with coverId" do
        it 'should return 200 HTTP status code with selection object' do
          selection = create(:selection)
          update_params = @params.clone
          update_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          update_params[:coverId] = @cover.id
          update_params[:promoted] = true

          request.headers['x-client-id'] = @admin_token
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
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:cover]).to_not be_empty
          expect(response_body[:cover][:id]).to eq(update_params[:coverId])
          expect(response_body[:cover][:originalUrl]).to eq(@cover.file_url)
          expect(response_body[:promoted]).to eq(update_params[:promoted])
          expect(response_body[:longDescription]).to eq(update_params[:longDescription])
        end
      end

      context "coverUrl and coverId are both sent" do
        it "should return 200 HTTP status code with selection object with only coverId" do
          selection = create(:selection)
          update_params = @params.clone
          update_params[:imageUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          update_params[:imageId] = @image.id
          update_params[:coverUrl] = "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
          update_params[:coverId] = @cover.id
          update_params[:promoted] = true

          request.headers['x-client-id'] = @admin_token
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
          expect(response_body[:image]).to_not be_empty
          expect(response_body[:image][:originalUrl]).to eq(@image.file_url)
          expect(response_body[:image][:id]).to eq(update_params[:imageId])
          expect(response_body[:cover]).to_not be_empty
          expect(response_body[:cover][:originalUrl]).to eq(@cover.file_url)
          expect(response_body[:cover][:id]).to eq(update_params[:coverId])
          expect(response_body[:promoted]).to eq(update_params[:promoted])
          expect(response_body[:longDescription]).to eq(update_params[:longDescription])
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
          wrong_id = 0
          update_params = {
            tagIds: [wrong_id]
          }
          post :patch, params: update_params.merge(id: selection.id)

          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Tag with 'id'=#{wrong_id}").to_h.to_json)
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
