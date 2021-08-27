require 'rails_helper'

RSpec.describe Api::V1::ShopsController, type: :controller do
  describe "GET #index" do
    context 'when location is blank' do
      it 'returns 400 HTTP status' do
        get :index
        should respond_with(400)
      end
    end

    context 'when location is unknown' do
      it 'returns a 404 HTTP status' do
        get :index, params: { location: 'somewhere-over-the-rainbow' }
        should respond_with(404)
      end
    end
  end

  describe 'GET #shop_summaries' do
    context "All ok" do
      context "when location" do
        it 'returns a searchkick result' do
          city = create(:city, slug: 'bordeaux')
          searchkick_result = Searchkick::HashWrapper.new({
            "_index" => "shops_v1_20210315094629392",
            "_type" => "_doc",
            "_id" => "4648",
            "_score" => 0.9988128,
            "name" => "Edessa kebab",
            "created_at" => "2020-05-10T09:07:03.576+02:00",
            "updated_at" => "2020-05-10T09:07:09.498+02:00",
            "slug" => "edessa-kebab",
            "shop_url" => "/fr/sable-sur-sarthe/boutiques/edessa-kebab",
            "category_tree_ids" => [2359, 2371],
            "category_tree_names" => ["Restauration",
                                      "Traiteur"],
            "baseline" => "pouet",
            "description" => "pouet",
            "brands_name" => [""],
            "city_label" => "bordeaux",
            "city_slug" => "bordeaux",
            "insee_code" => "72264",
            "territory_name" => "bordeaux",
            "territory_slug" => "bordeaux",
            "department_number" => "72",
            "deleted_at" => "pouet",
            "number_of_online_products" => 3,
            "number_of_orders" => 0,
            "image_url" => "default_box_shop.svg",
            "coupons" => "[]",
            "pictogram_url" => "pouet",
            "services" => ["click-collect",
                           "livraison-express-par-stuart",
                           "livraison-par-la-poste",
                           "livraison-par-colissimo",
                           "e-reservation"],
            "is_template" => false,
            "score" => 0,
            "indexed_at" => "2021-06-28T18:36:54.691+00:00",
            "id" => "4648",
          })
          allow(::Requests::ShopSearches).to receive(:search_highest_scored_shops).and_return([searchkick_result])
          allow(::Requests::ShopSearches).to receive(:search_random_shops).and_return([searchkick_result])

          get :shop_summaries, params: { location: city.slug  }
          should respond_with(200)
        end
      end
    end

    context "when problems" do
      context "location param is missing" do
        it "it returns a 400 http status" do
          get :shop_summaries
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: location.').to_h.to_json)
        end
      end

      context "location can't be found" do
        it "it returns a 400 http status" do
          get :shop_summaries, params: { location: 'Neo Detroit' }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new('Location not found.').to_h.to_json)
        end
      end
    end
  end

  describe "GET #show" do
    context "All ok" do
      it 'should return shop information' do
        shop = create(:shop)
        shop.address.addressable = shop
        shop.save

        get :show, params: {id: shop.id}

        expect(response).to have_http_status(200)
        expect(response.body).to eq(Dto::V1::Shop::Response.create(shop).to_h.to_json)
      end
    end

    context "Shop id is 0" do
      it 'should return 400 HTTP Status' do
        shop = create(:shop)

        get :show, params: {id: 0}

        expect(response).to have_http_status(400)
      end
    end

    context "Shop id is not numeric" do
      it 'should return 400 HTTP Status' do
        shop = create(:shop)

        get :show, params: {id: "jjei"}

        expect(response).to have_http_status(400)
      end
    end

    context "Shop doesn't exist" do
      before(:each) do
        Shop.destroy_all
      end
      it 'should return 404 HTTP Status' do
        get :show, params: {id: 200}

        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST #create" do
    context "All ok" do
      before(:each) do
        @categories = []
        @categories << create(:category)
        @categories << create(:homme)
      end
      it 'should return 201 HTTP status code with shop response object' do
        @create_params = {
          name: "Boutique Test",
          address: {
            streetNumber: "52",
            route: "Rue Georges Bonnac",
            locality: "Bordeaux",
            country: "France",
            postalCode: "33000",
            longitude: 44.8399608,
            latitude: 0.5862431,
            inseeCode: "33063"
          },
          email: "test@boutique.com",
          siret: "75409821800029",
          categoryIds: [
            @categories[0].id,
            @categories[1].id
          ],
          description: "Test description",
          baseline: "Test baseline",
          facebookLink: "http://www.facebook.com",
          instagramLink: "http://www.instagram.com",
          websiteLink: "http://www.website.com",
        }
        allow(City).to receive(:find_or_create_city).and_return(create(:city))

        shop_employee_user = create(:shop_employee_user, email: 'shop.employee789@ecity.fr')
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

        post :create, params: @create_params

        expect(response).to have_http_status(201)
        shop_result = JSON.parse(response.body)
        expect(shop_result["id"]).not_to be_nil
        expect(shop_result["name"]).to eq(@create_params[:name])
        expect(shop_result["siret"]).to eq(@create_params[:siret])
        expect(shop_result["email"]).to eq(@create_params[:email])
        expect(shop_result["address"]["streetNumber"]).to eq(@create_params[:address][:streetNumber])
        expect(shop_result["address"]["route"]).to eq(@create_params[:address][:route])
        expect(shop_result["address"]["locality"]).to eq(@create_params[:address][:locality])
        expect(shop_result["address"]["country"]).to eq(@create_params[:address][:country])
        expect(shop_result["address"]["postalCode"]).to eq(@create_params[:address][:postalCode])
        expect(shop_result["address"]["longitude"]).to eq(@create_params[:address][:longitude])
        expect(shop_result["address"]["latitude"]).to eq(@create_params[:address][:latitude])
        expect(shop_result["description"]).to eq(@create_params[:description])
        expect(shop_result["baseline"]).to eq(@create_params[:baseline])
        expect(shop_result["facebookLink"]).to eq(@create_params[:facebookLink])
        expect(shop_result["instagramLink"]).to eq(@create_params[:instagramLink])
        expect(shop_result["websiteLink"]).to eq(@create_params[:websiteLink])
        expect((Shop.find(shop_result["id"]).owner == shop_employee_user.shop_employee)).to be_truthy
      end
    end

    context "Bad params" do
      context "No Name" do
        before(:each) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        it "should return 400 HTTP status" do
          @create_params = {
            address: {
              streetNumber: "52",
              route: "Rue Georges Bonnac",
              locality: "Bordeaux",
              country: "France",
              postalCode: "33000",
              longitude: 44.8399608,
              latitude: 0.5862431
            },
            email: "test@boutique.com",
            siret: "75409821800029",
            categoryIds: [
              @categories[0].id,
              @categories[1].id
            ]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee876@ecity.fr')

          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          post :create, params: @create_params

          expect(response).to have_http_status(400)
        end

      end
      context "No Siret" do
        before(:each) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        it "should return 400 HTTP status" do
          @create_params = {
            name: "Boutique test",
            address: {
              streetNumber: "52",
              route: "Rue Georges Bonnac",
              locality: "Bordeaux",
              country: "France",
              postalCode: "33000",
              longitude: 44.8399608,
              latitude: 0.5862431
            },
            email: "test@boutique.com",
            categoryIds: [
              @categories[0].id,
              @categories[1].id
            ]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee877@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          post :create, params: @create_params

          expect(response).to have_http_status(400)
        end

      end
      context "No Category" do
        it "should return 400 HTTP status" do
          @create_params = {
            address: {
              streetNumber: "52",
              route: "Rue Georges Bonnac",
              locality: "Bordeaux",
              country: "France",
              postalCode: "33000",
              longitude: 44.8399608,
              latitude: 0.5862431
            },
            email: "test@boutique.com",
            siret: "75409821800029",
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee878@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          post :create, params: @create_params

          expect(response).to have_http_status(400)
        end

      end
      context "No Address" do
        before(:each) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        it "should return 400 HTTP status" do
          @create_params = {
            email: "test@boutique.com",
            siret: "75409821800029",
            categoryIds: [
              @categories[0].id,
              @categories[1].id
            ]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee878@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          post :create, params: @create_params

          expect(response).to have_http_status(400)
        end

      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          post :create
          expect(response).to have_http_status(401)
        end
      end

      context "User is not a pro" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          post :create
          expect(response).to have_http_status(403)
        end
      end

      context "User is admin" do
        before(:each) do
          @admin_user = create(:admin_user)
        end
        it "should return 403" do
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(@admin_user)
          post :create
          expect(response).to have_http_status(403)
        end
      end
    end
  end

  describe "PUT #update" do
    context "All ok" do
      before(:each) do
        @categories = []
        @categories << create(:category)
        @categories << create(:homme)
        @shop = create(:shop)
        @city = create(:city)
        @shop.city_id = @city.id
        @shop.save
        @shop_address = create(:address, city: @city)
        @shop_address.addressable_id = @shop.id
        @shop_address.addressable_type = "Shop"
        @shop_address.save
      end
      it 'should return 200 HTTP status code with shop response object' do
        @update_params = {
          name: "Boutique Test",
          email: @shop.email,
          siret: @shop.siret,
          address: {
            streetNumber: @shop.address.street_number,
            route: @shop.address.route,
            locality: @shop.address.locality,
            country: @shop.address.country,
            postalCode: @shop.address.postal_code,
            longitude: @shop.address.longitude,
            latitude: @shop.address.latitude,
            inseeCode: @shop.address.city.insee_code
          },
          facebookLink: "http://www.facebook.com",
          instagramLink: "http://www.instagram.com",
          websiteLink: "http://www.website.com"
        }
        shop_employee_user = create(:shop_employee_user, email: 'shop.employee78@ecity.fr')
        @shop.assign_ownership(shop_employee_user)
        @shop.save
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

        put :update, params: @update_params.merge({id: @shop.id})

        expect(response).to have_http_status(200)
        shop_result = JSON.parse(response.body)
        expect(shop_result["id"]).not_to be_nil
        expect(shop_result["name"]).to eq(@update_params[:name])
        expect(shop_result["siret"]).to eq(@shop.siret)
        expect(shop_result["email"]).to eq(@shop.email)
        expect(shop_result["address"]["streetNumber"]).to eq(@shop.address.street_number)
        expect(shop_result["address"]["route"]).to eq(@shop.address.route)
        expect(shop_result["address"]["locality"]).to eq(@shop.address.locality)
        expect(shop_result["address"]["country"]).to eq(@shop.address.country)
        expect(shop_result["address"]["postalCode"]).to eq(@shop.address.postal_code)
        expect(shop_result["address"]["longitude"]).to eq(@shop.address.longitude)
        expect(shop_result["address"]["latitude"]).to eq(@shop.address.latitude)
        expect(shop_result["facebookLink"]).to eq(@update_params[:facebookLink])
        expect(shop_result["instagramLink"]).to eq(@update_params[:instagramLink])
        expect(shop_result["websiteLink"]).to eq(@update_params[:websiteLink])
        expect((Shop.find(shop_result["id"]).owner == shop_employee_user.shop_employee)).to be_truthy
      end
    end

    context 'Shop not found' do
      it 'Should return 404 HTTP status' do
        shop_employee_user = create(:shop_employee_user, email: 'shop.employee5678@ecity.fr')

        shop = create(:shop)
        Shop.destroy_all

        request.headers["HTTP_X_CLIENT_ID"] = generate_token(shop_employee_user)
        put :update, params: {id: shop.id}

        expect(response).to have_http_status(404)
        expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{shop.id}").to_h.to_json)
      end
    end

    context "Bad params" do
      context "No Name" do
        before(:each) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        it "should return 400 HTTP status" do
          @update_params = {
            address: {
              streetNumber: "52",
              route: "Rue Georges Bonnac",
              locality: "Bordeaux",
              country: "France",
              postalCode: "33000",
              longitude: 44.8399608,
              latitude: 0.5862431
            },
            email: "test@boutique.com",
            siret: "75409821800029",
            categoryIds: [
              @categories[0].id,
              @categories[1].id
            ]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee5678@ecity.fr')
          shop = create(:shop)
          shop.assign_ownership(shop_employee_user)
          shop.save

          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          put :update, params: @update_params.merge(id: shop.id)

          expect(response).to have_http_status(400)
        end

      end
      context "No Siret" do
        before(:each) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        it "should return 400 HTTP status" do
          @update_params = {
            name: "Boutique test",
            address: {
              streetNumber: "52",
              route: "Rue Georges Bonnac",
              locality: "Bordeaux",
              country: "France",
              postalCode: "33000",
              longitude: 44.8399608,
              latitude: 0.5862431
            },
            email: "test@boutique.com",
            categoryIds: [
              @categories[0].id,
              @categories[1].id
            ]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee5679@ecity.fr')
          shop = create(:shop)
          shop.assign_ownership(shop_employee_user)
          shop.save
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          put :update, params: @update_params.merge(id: shop.id)

          expect(response).to have_http_status(400)
        end

      end
      context "No Category" do
        it "should return 400 HTTP status" do
          @update_params = {
            address: {
              streetNumber: "52",
              route: "Rue Georges Bonnac",
              locality: "Bordeaux",
              country: "France",
              postalCode: "33000",
              longitude: 44.8399608,
              latitude: 0.5862431
            },
            email: "test@boutique.com",
            siret: "75409821800029",
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee5680@ecity.fr')
          shop = create(:shop)
          shop.assign_ownership(shop_employee_user)
          shop.save
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          put :update, params: @update_params.merge(id: shop.id)

          expect(response).to have_http_status(400)
        end

      end
      context "No Address" do
        before(:each) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        it "should return 400 HTTP status" do
          @update_params = {
            email: "test@boutique.com",
            siret: "75409821800029",
            categoryIds: [
              @categories[0].id,
              @categories[1].id
            ]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee5681@ecity.fr')
          shop = create(:shop)
          shop.assign_ownership(shop_employee_user)
          shop.save

          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          put :update, params: @update_params.merge(id: shop.id)

          expect(response).to have_http_status(400)
        end

      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          put :update, params: {id: 33}
          expect(response).to have_http_status(401)
        end
      end

      context "User is not a pro" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer5678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          put :update, params: {id: 33}
          expect(response).to have_http_status(403)
        end
      end

      context "User is admin" do
        before(:each) do
          @admin_user = create(:admin_user)
        end
        it "should return 403" do
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(@admin_user)
          put :update, params: {id: 33}
          expect(response).to have_http_status(403)
        end
      end

      context "User is not the owner of shop" do
        it "Should return 403 HTTP Status" do
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee536@ecity.fr')
          @shop = create(:shop)
          request.headers["HTTP_X_CLIENT_ID"] = generate_token(shop_employee_user)
          put :update, params: {id: @shop.id}

          expect(response).to have_http_status(403)
        end
      end
    end
  end
end

def generate_token(user)
  exp_payload = { id: user.id, exp: Time.now.to_i + 1 * 3600 * 24 }
  JWT.encode exp_payload, ENV["JWT_SECRET"], 'HS256'
end
