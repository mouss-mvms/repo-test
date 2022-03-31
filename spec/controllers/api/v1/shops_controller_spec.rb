require 'rails_helper'

RSpec.describe Api::V1::ShopsController, type: :controller do

  describe "GET #show" do
    context "All ok" do
      it 'should return shop information' do
        shop = create(:shop)
        create(:address, addressable: shop)
        shop.address.addressable = shop
        shop.save

        get :show, params: { id: shop.id }

        expect(response).to have_http_status(200)
        expect(response.body).to eq(Dto::V1::Shop::Response.create(shop).to_h.to_json)
      end

      it 'should return http status 304' do
        shop = create(:shop)
        create(:address, addressable: shop)
        shop.address.addressable = shop
        shop.save
        get :show, params: { id: shop.id }
        expect(response).to have_http_status(200)

        etag = response.headers["ETag"]
        request.env["HTTP_IF_NONE_MATCH"] = etag
        get :show, params: { id: shop.id }

        expect(response).to have_http_status(304)
      end
    end

    context "Shop id is 0" do
      it 'should return 400 HTTP Status' do
        shop = create(:shop)

        get :show, params: { id: 0 }

        expect(response).to have_http_status(400)
      end
    end

    context "Shop id is not numeric" do
      it 'should return 400 HTTP Status' do
        get :show, params: { id: "jjei" }

        expect(response).to have_http_status(400)
      end
    end

    context "Shop doesn't exist" do
      it 'should return 404 HTTP Status' do
        shop = create(:shop)
        shop.destroy
        get :show, params: { id: shop.id }

        expect(response).to have_http_status(404)
        expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{response.request.params[:id]}").to_h.to_json)
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

      context "with avatar, cover, and images as ids" do
        it 'should return 201 HTTP status code with shop response object' do
          image = create(:image)
          @create_params = {
            name: "Boutique Test",
            avatarId: image.id,
            coverId: image.id,
            imageIds: [image.id],
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
            mobileNumber: "0666666666",
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
          allow(City).to receive(:find_or_create_city).and_return(create(:old_city_factory))

          shop_employee_user = create(:shop_employee_user, email: 'shop.employee789@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          post :create, params: @create_params

          expect(response).to have_http_status(201)
          shop_result = JSON.parse(response.body)
          expect(shop_result["id"]).not_to be_nil
          expect(shop_result["name"]).to eq(@create_params[:name])
          expect(shop_result["siret"]).to eq(@create_params[:siret])
          expect(shop_result["email"]).to eq(@create_params[:email])
          expect(shop_result["avatar"]["id"]).to eq(image.id)
          expect(shop_result["avatar"]["originalUrl"]).to eq(image.file_url)
          expect(shop_result["cover"]["id"]).to eq(image.id)
          expect(shop_result["cover"]["originalUrl"]).to eq(image.file_url)
          expect(shop_result["images"].count).to eq(@create_params[:imageIds].count)
          expect(shop_result["images"].first["id"]).to_not be_blank
          expect(shop_result["images"].first["originalUrl"]).to_not be_blank
          expect(shop_result["mobileNumber"]).to eq(@create_params[:mobileNumber])
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

      context "with avatar, cover, and images as urls" do
        it 'should return 201 HTTP status code with shop response object' do
          @create_params = {
            name: "Boutique Test",
            avatarUrl: "https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg",
            coverUrl: "https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg",
            imageUrls: ["https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg"],
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
            mobileNumber: "0666666666",
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
          allow(City).to receive(:find_or_create_city).and_return(create(:old_city_factory))

          shop_employee_user = create(:shop_employee_user, email: 'shop.employee789@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          post :create, params: @create_params

          expect(response).to have_http_status(201)
          shop_result = JSON.parse(response.body)
          expect(shop_result["id"]).not_to be_nil
          expect(shop_result["name"]).to eq(@create_params[:name])
          expect(shop_result["siret"]).to eq(@create_params[:siret])
          expect(shop_result["email"]).to eq(@create_params[:email])
          expect(shop_result["avatar"]["id"]).to_not be_blank
          expect(shop_result["avatar"]["originalUrl"]).to_not be_blank
          expect(shop_result["cover"]["id"]).to_not be_blank
          expect(shop_result["cover"]["originalUrl"]).to_not be_blank
          expect(shop_result["images"].count).to eq(@create_params[:imageUrls].count)
          expect(shop_result["mobileNumber"]).to eq(@create_params[:mobileNumber])
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

      context "with avatar, cover, and images as urls and ids" do
        it 'should return 201 HTTP status code with shop response object and image ids preferred' do
          image = create(:image)
          @create_params = {
            name: "Boutique Test",
            avatarUrl: "https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg",
            coverUrl: "https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg",
            imageUrls: ["https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg"],
            avatarId: image.id,
            coverId: image.id,
            imageIds: [image.id],
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
            mobileNumber: "0666666666",
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
          allow(City).to receive(:find_or_create_city).and_return(create(:old_city_factory))

          shop_employee_user = create(:shop_employee_user, email: 'shop.employee789@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          post :create, params: @create_params

          expect(response).to have_http_status(201)
          shop_result = JSON.parse(response.body)
          expect(shop_result["id"]).not_to be_nil
          expect(shop_result["name"]).to eq(@create_params[:name])
          expect(shop_result["siret"]).to eq(@create_params[:siret])
          expect(shop_result["email"]).to eq(@create_params[:email])
          expect(shop_result["avatar"]["id"]).to eq(image.id)
          expect(shop_result["avatar"]["originalUrl"]).to eq(image.file_url)
          expect(shop_result["cover"]["id"]).to eq(image.id)
          expect(shop_result["cover"]["originalUrl"]).to eq(image.file_url)
          expect(shop_result["images"].count).to eq(@create_params[:imageIds].count)
          expect(shop_result["mobileNumber"]).to eq(@create_params[:mobileNumber])
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
      context "Bad params address" do
        before(:all) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        after(:all) do
          @categories.each { |cat| cat.destroy }
        end

        context "No locality params in address params" do
          it "should return 400 HTTP status" do
            @create_params = {
              name: "Boutique Test",
              address: {
                streetNumber: "52",
                route: "Rue Georges Bonnac",
                country: "France",
                postalCode: "33000",
                longitude: 44.8399608,
                latitude: 0.5862431,
                inseeCode: "33063"
              },
              email: "test@boutique.com",
              mobileNumber: "0666666666",
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
            shop_employee_user = create(:shop_employee_user, email: 'shop.employee878@ecity.fr')
            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            post :create, params: @create_params

            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: locality").to_h.to_json)
          end
        end

        context "No country params in address params" do
          it "should return 400 HTTP status" do
            @create_params = {
              name: "Boutique Test",
              address: {
                streetNumber: "52",
                route: "Rue Georges Bonnac",
                locality: "Bordeaux",
                postalCode: "33000",
                longitude: 44.8399608,
                latitude: 0.5862431,
                inseeCode: "33063"
              },
              email: "test@boutique.com",
              mobileNumber: "0666666666",
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
            shop_employee_user = create(:shop_employee_user, email: 'shop.employee878@ecity.fr')
            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            post :create, params: @create_params

            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: country").to_h.to_json)
          end
        end

        context "No route params in address params" do
          it "should return 400 HTTP status" do
            @create_params = {
              name: "Boutique Test",
              address: {
                streetNumber: "52",
                locality: "Bordeaux",
                country: "France",
                postalCode: "33000",
                longitude: 44.8399608,
                latitude: 0.5862431,
                inseeCode: "33063"
              },
              email: "test@boutique.com",
              mobileNumber: "0666666666",
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
            shop_employee_user = create(:shop_employee_user, email: 'shop.employee878@ecity.fr')
            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            post :create, params: @create_params

            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: route").to_h.to_json)
          end
        end
      end
      context "Bad params for images" do
        before(:all) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        after(:all) do
          @categories.each { |cat| cat.destroy }
        end
        context "avatar not found" do
          it "should return 404 HTTP status" do
            image = create(:image)
            @create_params = {
              name: "Boutique Test",
              avatarId: 0,
              coverId: image.id,
              imageIds: [image.id],
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
              mobileNumber: "0666666666",
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
            allow(City).to receive(:find_or_create_city).and_return(create(:old_city_factory))

            shop_employee_user = create(:shop_employee_user, email: 'shop.employee789@ecity.fr')
            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            post :create, params: @create_params
            expect(response).to have_http_status(404)
          end
        end

        context "cover not found" do
          it "should return 404 HTTP status" do
            image = create(:image)
            @create_params = {
              name: "Boutique Test",
              avatarId: image.id,
              coverId: 0,
              imageIds: [image.id],
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
              mobileNumber: "0666666666",
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
            allow(City).to receive(:find_or_create_city).and_return(create(:old_city_factory))

            shop_employee_user = create(:shop_employee_user, email: 'shop.employee789@ecity.fr')
            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            post :create, params: @create_params
            expect(response).to have_http_status(404)
          end
        end

        context "images not found" do
          it "should return 404 HTTP status" do
            image = create(:image)
            @create_params = {
              name: "Boutique Test",
              avatarId: image.id,
              coverId: image.id,
              imageIds: [image.id, 0],
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
              mobileNumber: "0666666666",
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
            allow(City).to receive(:find_or_create_city).and_return(create(:old_city_factory))

            shop_employee_user = create(:shop_employee_user, email: 'shop.employee789@ecity.fr')
            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            post :create, params: @create_params
            expect(response).to have_http_status(404)
          end
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
        @city = create(:old_city_factory)
        @shop.city_id = @city.id
        @shop.save
        @shop_address = create(:address, city: @city)
        @shop_address.addressable_id = @shop.id
        @shop_address.addressable_type = "Shop"
        @shop_address.save
      end

      context "with avatar, cover and images as ids" do
        it 'should return 200 HTTP status code with shop response object' do
          image = create(:image)
          @update_params = {
            name: "Boutique Test",
            email: @shop.email,
            mobileNumber: "0666666666",
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
            description: "Description mise à jour de la boutique",
            baseline: "Baseline mise à jour de la boutique",
            facebookLink: "http://www.facebook.com",
            instagramLink: "http://www.instagram.com",
            websiteLink: "http://www.website.com",
            avatarId: image.id,
            coverId: image.id,
            imageIds: [image.id]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee78@ecity.fr')
          @shop.assign_ownership(shop_employee_user)
          @shop.profil&.file_url = nil
          @shop.descriptions << I18nshop.new(lang: "fr", field: "description", content: "Description de la boutique")
          @shop.baselines << I18nshop.new(lang: "fr", field: "Baseline", content: "Baseline de la boutique")
          @shop.save
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          put :update, params: @update_params.merge({ id: @shop.id })

          expect(response).to have_http_status(200)
          shop_result = JSON.parse(response.body)
          expect(shop_result["id"]).not_to be_nil
          expect(shop_result["name"]).to eq(@update_params[:name])
          expect(shop_result["siret"]).to eq(@shop.siret)
          expect(shop_result["email"]).to eq(@shop.email)
          expect(shop_result["description"]).to eq(@update_params[:description])
          expect(shop_result["baseline"]).to eq(@update_params[:baseline])
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
          expect(shop_result["avatar"]["id"]).to eq(image.id)
          expect(shop_result["avatar"]["originalUrl"]).to eq(image.file_url)
          expect(shop_result["cover"]["id"]).to eq(image.id)
          expect(shop_result["cover"]["originalUrl"]).to eq(image.file_url)
          expect(shop_result["images"].count).to eq(@update_params[:imageIds].count)
          expect(shop_result["images"].first["id"]).to_not be_blank
          expect(shop_result["images"].first["originalUrl"]).to_not be_blank
          expect((Shop.find(shop_result["id"]).owner == shop_employee_user.shop_employee)).to be_truthy
        end
      end

      context "with avatar, cover and images as urls" do
        it 'should return 200 HTTP status code with shop response object' do
          image = create(:image)
          @update_params = {
            name: "Boutique Test",
            email: @shop.email,
            mobileNumber: "0666666666",
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
            description: "Description mise à jour de la boutique",
            baseline: "Baseline mise à jour de la boutique",
            facebookLink: "http://www.facebook.com",
            instagramLink: "http://www.instagram.com",
            websiteLink: "http://www.website.com",
            avatarUrl: "https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg",
            coverUrl: "https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg",
            imageUrls: ["https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg"]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee78@ecity.fr')
          @shop.assign_ownership(shop_employee_user)
          @shop.profil&.file_url = nil
          @shop.descriptions << I18nshop.new(lang: "fr", field: "description", content: "Description de la boutique")
          @shop.baselines << I18nshop.new(lang: "fr", field: "Baseline", content: "Baseline de la boutique")
          @shop.save
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          put :update, params: @update_params.merge({ id: @shop.id })

          expect(response).to have_http_status(200)
          shop_result = JSON.parse(response.body)
          expect(shop_result["id"]).not_to be_nil
          expect(shop_result["name"]).to eq(@update_params[:name])
          expect(shop_result["siret"]).to eq(@shop.siret)
          expect(shop_result["email"]).to eq(@shop.email)
          expect(shop_result["description"]).to eq(@update_params[:description])
          expect(shop_result["baseline"]).to eq(@update_params[:baseline])
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
          expect(shop_result["avatar"]["id"]).to_not be_blank
          expect(shop_result["avatar"]["originalUrl"]).to_not be_blank
          expect(shop_result["cover"]["id"]).to_not be_blank
          expect(shop_result["cover"]["originalUrl"]).to_not be_blank
          expect(shop_result["images"].count).to eq(@update_params[:imageUrls].count)
          expect((Shop.find(shop_result["id"]).owner == shop_employee_user.shop_employee)).to be_truthy
        end
      end

      context "with avatar, cover and images as ids and urls" do
        it 'should return 200 HTTP status code with shop response object and image ids preferred' do
          image = create(:image)
          @update_params = {
            name: "Boutique Test",
            email: @shop.email,
            mobileNumber: "0666666666",
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
            description: "Description mise à jour de la boutique",
            baseline: "Baseline mise à jour de la boutique",
            facebookLink: "http://www.facebook.com",
            instagramLink: "http://www.instagram.com",
            websiteLink: "http://www.website.com",
            avatarId: image.id,
            coverId: image.id,
            imageIds: [image.id],
            avatarUrl: "https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg",
            coverUrl: "https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg",
            imageUrls: ["https://dragonballsuper-france.fr/wp-content/uploads/2018/11/final.mp4_snapshot_00.35_2018.11.08_00.18.50-1.jpg"]
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee78@ecity.fr')
          @shop.assign_ownership(shop_employee_user)
          @shop.profil&.file_url = nil
          @shop.descriptions << I18nshop.new(lang: "fr", field: "description", content: "Description de la boutique")
          @shop.baselines << I18nshop.new(lang: "fr", field: "Baseline", content: "Baseline de la boutique")
          @shop.save
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          put :update, params: @update_params.merge({ id: @shop.id })

          expect(response).to have_http_status(200)
          shop_result = JSON.parse(response.body)
          expect(shop_result["id"]).not_to be_nil
          expect(shop_result["name"]).to eq(@update_params[:name])
          expect(shop_result["siret"]).to eq(@shop.siret)
          expect(shop_result["email"]).to eq(@shop.email)
          expect(shop_result["description"]).to eq(@update_params[:description])
          expect(shop_result["baseline"]).to eq(@update_params[:baseline])
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
          expect(shop_result["avatar"]["id"]).to eq(image.id)
          expect(shop_result["avatar"]["originalUrl"]).to eq(image.file_url)
          expect(shop_result["cover"]["id"]).to eq(image.id)
          expect(shop_result["cover"]["originalUrl"]).to eq(image.file_url)
          expect(shop_result["images"].count).to eq(@update_params[:imageIds].count)
          expect(shop_result["images"].first["id"]).to_not be_blank
          expect(shop_result["images"].first["originalUrl"]).to_not be_blank
          expect((Shop.find(shop_result["id"]).owner == shop_employee_user.shop_employee)).to be_truthy
        end
      end

      context 'Shop has no description' do
        it 'should return 200 HTTP status code with shop response object and description' do
          avatar_image = create(:image)
          @update_params = {
            name: "Boutique Test",
            email: @shop.email,
            mobileNumber: "0666666666",
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
            description: "Description mise à jour de la boutique",
            baseline: "Baseline mise à jour de la boutique",
            facebookLink: "http://www.facebook.com",
            instagramLink: "http://www.instagram.com",
            websiteLink: "http://www.website.com",
            avatarId: avatar_image.id
          }
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee78@ecity.fr')
          @shop.assign_ownership(shop_employee_user)
          @shop.profil&.file_url = nil
          @shop.baselines << I18nshop.new(lang: "fr", field: "Baseline", content: "Baseline de la boutique")
          @shop.save
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

          put :update, params: @update_params.merge({ id: @shop.id })

          expect(response).to have_http_status(200)
          shop_result = JSON.parse(response.body)
          expect(shop_result["id"]).not_to be_nil
          expect(shop_result["name"]).to eq(@update_params[:name])
          expect(shop_result["siret"]).to eq(@shop.siret)
          expect(shop_result["email"]).to eq(@shop.email)
          expect(shop_result["description"]).to eq(@update_params[:description])
          expect(shop_result["baseline"]).to eq(@update_params[:baseline])
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
          expect(shop_result["avatar"].blank?).to be_falsey
          expect((Shop.find(shop_result["id"]).owner == shop_employee_user.shop_employee)).to be_truthy
        end

      end
    end

    context "Bad params" do
      context "images bad params" do
        before(:each) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        context "Avatar image not found" do
          it "returns a 404 http status" do
            image = create(:image)
            wrong_avatar_id = image.id
            @update_params = {
              name: "oui",
              email: "test@boutique.com",
              siret: "75409821800029",
              mobileNumber: "0666666666",
              categoryIds: [
                @categories[0].id,
                @categories[1].id
              ],
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
              avatarId: wrong_avatar_id
            }
            shop_employee_user = create(:shop_employee_user, email: 'shop.employee5681@ecity.fr')
            shop = create(:shop)
            shop.assign_ownership(shop_employee_user)
            shop.save

            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            image.delete

            put :update, params: @update_params.merge(id: shop.id)
            expect(response).to have_http_status(404)
          end
        end

        context "Cover not found" do
          it "should return 400 HTTP status" do
            wrong_id = 0
            @update_params = {
              name: "La boutique de Chuck",
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
              ],
              coverId: wrong_id
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

        context "Cover not found" do
          it "should return 400 HTTP status" do
            wrong_id = 0
            @update_params = {
              name: "La boutique de Chuck",
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
              ],
              imageIds: [wrong_id]
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

      end
      context 'Shop not found' do
        it 'Should return 404 HTTP status' do
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee5678@ecity.fr')

          shop = create(:shop)
          shop.destroy

          request.headers["HTTP_X_CLIENT_ID"] = generate_token(shop_employee_user)
          put :update, params: { id: shop.id }

          expect(response).to have_http_status(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{shop.id}").to_h.to_json)
        end
      end
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
        before(:all) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        after(:all) do
          @categories.each { |category| category.destroy }
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
      context "Bad Params Address" do
        before(:all) do
          @categories = []
          @categories << create(:category)
          @categories << create(:homme)
        end
        after(:all) do
          @categories.each { |category| category.destroy }
        end
        context "No locality params in address params" do
          it "should return 400 HTTP status" do
            @update_params = {
              name: "oui",
              mobileNumber: "0666666666",
              email: "test@boutique.com",
              siret: "75409821800029",
              categoryIds: [
                @categories[0].id,
                @categories[1].id
              ],
              address: {
                streetNumber: "52",
                route: "Rue Georges Bonnac",
                country: "France",
                postalCode: "33000",
                longitude: 44.8399608,
                latitude: 0.5862431
              }
            }
            shop_employee_user = create(:shop_employee_user, email: 'shop.employee5681@ecity.fr')
            shop = create(:shop)
            shop.assign_ownership(shop_employee_user)
            shop.save

            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            put :update, params: @update_params.merge(id: shop.id)

            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: locality").to_h.to_json)
          end
        end
        context "No country params in address params" do
          it "should return 400 HTTP status" do
            @update_params = {
              name: "oui",
              email: "test@boutique.com",
              mobileNumber: "0666666666",
              siret: "75409821800029",
              categoryIds: [
                @categories[0].id,
                @categories[1].id
              ],
              address: {
                streetNumber: "52",
                route: "Rue Georges Bonnac",
                locality: "Bordeaux",
                postalCode: "33000",
                longitude: 44.8399608,
                latitude: 0.5862431
              }
            }
            shop_employee_user = create(:shop_employee_user, email: 'shop.employee5681@ecity.fr')
            shop = create(:shop)
            shop.assign_ownership(shop_employee_user)
            shop.save

            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            put :update, params: @update_params.merge(id: shop.id)

            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: country").to_h.to_json)
          end
        end
        context "No route params in address params" do
          it "should return 400 HTTP status" do
            @update_params = {
              name: "oui",
              email: "test@boutique.com",
              siret: "75409821800029",
              mobileNumber: "0666666666",
              categoryIds: [
                @categories[0].id,
                @categories[1].id
              ],
              address: {
                streetNumber: "52",
                locality: "Bordeaux",
                country: "France",
                postalCode: "33000",
                longitude: 44.8399608,
                latitude: 0.5862431
              }
            }
            shop_employee_user = create(:shop_employee_user, email: 'shop.employee5681@ecity.fr')
            shop = create(:shop)
            shop.assign_ownership(shop_employee_user)
            shop.save

            request.headers['HTTP_X_CLIENT_ID'] = generate_token(shop_employee_user)

            put :update, params: @update_params.merge(id: shop.id)

            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: route").to_h.to_json)
          end
        end
      end

    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          put :update, params: { id: 33 }
          expect(response).to have_http_status(401)
        end
      end

      context "User is not a pro" do
        it "should return 403" do
          customer_user = create(:customer_user, email: 'customer5678@ecity.fr')
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(customer_user)
          put :update, params: { id: 33 }
          expect(response).to have_http_status(403)
        end
      end

      context "User is admin" do
        before(:each) do
          @admin_user = create(:admin_user)
        end
        it "should return 403" do
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(@admin_user)
          put :update, params: { id: 33 }
          expect(response).to have_http_status(403)
        end
      end

      context "User is not the owner of shop" do
        it "Should return 403 HTTP Status" do
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee536@ecity.fr')
          @shop = create(:shop)
          request.headers["HTTP_X_CLIENT_ID"] = generate_token(shop_employee_user)
          put :update, params: { id: @shop.id }

          expect(response).to have_http_status(403)
        end
      end
    end
  end

  describe "PATCH #patch" do
    before(:all) do
      @shop = create(:shop)
      create(:address, addressable: @shop)
      @user = create(:user, admin: create(:admin))
      @user_token = generate_token(@user)
    end

    after(:all) do
      @user_token = nil
      @user.destroy
      @shop.addresses.destroy_all
      @shop.destroy
    end

    context "All ok" do
      before(:all) do
        @city_referential = create(:city_referential, insee_code: '33063', name: 'Bordeaux', label: 'Bordeaux', department: '33')
        @city = create(:city, name: 'Bordeaux', insee_code: '33063', zip_code: '33000', slug: 'bordeaux')
      end

      after(:all) do
        @city_referential.destroy
        @city.destroy
      end

      context "User is a shop's owner" do
        before(:all) do
          @user = create(:user, email: 'shop_employee517382@test.fr', shop_employee: create(:shop_employee, shops: [@shop]))
          @shop.update(owner: @user.shop_employee)
          @user_token = generate_token(@user)
        end

        after(:all) do
          @user_token = nil
          @user.destroy
        end

        it "should return 200 HTTP status with shop's informations updated" do
          # Prepare
          request.headers["HTTP_X_CLIENT_ID"] = @user_token

          # Execute
          patch :patch, params: { id: @shop.id,
                                  name: 'Nom boutique MAJ',
                                  email: 'maj-email@test.com',
                                  siret: '75409821800029',
                                  description: 'Description MAJ',
                                  mobileNumber: '0612345678',
                                  baseline: 'Baseline MAJ',
                                  facebookLink: 'https://www.facebook.com/dummy/test',
                                  instagramLink: 'https://www.instagram.com/dummy/test',
                                  websiteLink: 'https://www.dummy.com',
                                  address: {
                                    streetNumber: '52',
                                    route: 'Rue Georges Bonnac',
                                    locality: 'Bordeaux',
                                    country: 'France',
                                    postalCode: '33000',
                                    latitude: 44.84006,
                                    longitude: -0.58397,
                                    inseeCode: '33063'
                                  }
          }

          # Assert
          expect(response).to have_http_status(:ok)
          result = JSON.parse(response.body, symbolize_names: true)
          expect(result[:name]).to eq(response.request.params[:name])
          expect(result[:email]).to eq(response.request.params[:email])
          expect(result[:mobileNumber]).to eq(response.request.params[:mobileNumber])
          expect(result[:siret]).to eq(response.request.params[:siret])
          expect(result[:description]).to eq(response.request.params[:description])
          expect(result[:baseline]).to eq(response.request.params[:baseline])
          expect(result[:facebookLink]).to eq(response.request.params[:facebookLink])
          expect(result[:instagramLink]).to eq(response.request.params[:instagramLink])
          expect(result[:websiteLink]).to eq(response.request.params[:websiteLink])
          expect(result[:address]).not_to be_nil
          expect(result[:address][:streetNumber]).to eq(response.request.params[:address][:streetNumber])
          expect(result[:address][:route]).to eq(response.request.params[:address][:route])
          expect(result[:address][:locality]).to eq(response.request.params[:address][:locality])
          expect(result[:address][:country]).to eq(response.request.params[:address][:country])
          expect(result[:address][:postalCode]).to eq(response.request.params[:address][:postalCode])
          expect(result[:address][:latitude]).to eq(response.request.params[:address][:latitude])
          expect(result[:address][:longitude]).to eq(response.request.params[:address][:longitude])
          expect(result[:address][:inseeCode]).to eq(response.request.params[:address][:inseeCode])
        end

        context 'ImageUrl is set' do
          context 'For avatar' do
            it 'should 200 HTTP status with avatar image set' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, avatarUrl: 'http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg'}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:avatar]).not_to be_nil
            end
          end

          context 'For cover' do
            it 'should 200 HTTP status with cover image set' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, coverUrl: 'http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg'}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:cover]).not_to be_nil
            end
          end

          context 'For thumbnail' do
            it 'should 200 HTTP status with thumbnail image set' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, thumbnailUrl: 'http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg'}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:thumbnail]).not_to be_nil
            end
          end
        end

        context 'ImageId is set' do
          before(:each) do
            @image = create(:image)
          end
          context 'For avatar' do
            it 'should 200 HTTP status with profil image updated' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, avatarId: @image.id}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:avatar]).not_to be_nil
              expect(@shop.reload.profil.id).to eq(@image.id)
              expect(result[:avatar][:id]).to eq(@image.id)
              expect(result[:avatar][:originalUrl]).to eq(@image.file_url)
              expect(result[:avatar][:miniUrl]).to eq(@image.file_url(:mini))
              expect(result[:avatar][:thumbUrl]).to eq(@image.file_url(:thumb))
              expect(result[:avatar][:squareUrl]).to eq(@image.file_url(:square))
              expect(result[:avatar][:wideUrl]).to eq(@image.file_url(:wide))
            end
          end

          context 'For cover' do
            it 'should 200 HTTP status with cover image updated' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, coverId: @image.id}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:cover]).not_to be_nil
              expect(@shop.reload.featured.id).to eq(@image.id)
              expect(result[:cover][:id]).to eq(@image.id)
              expect(result[:cover][:originalUrl]).to eq(@image.file_url)
              expect(result[:cover][:miniUrl]).to eq(@image.file_url(:mini))
              expect(result[:cover][:thumbUrl]).to eq(@image.file_url(:thumb))
              expect(result[:cover][:squareUrl]).to eq(@image.file_url(:square))
              expect(result[:cover][:wideUrl]).to eq(@image.file_url(:wide))
            end
          end

          context 'For thumbnail' do
            it 'should 200 HTTP status with thumbnail image updated' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, thumbnailId: @image.id}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:thumbnail]).not_to be_nil
              expect(@shop.reload.thumbnail.id).to eq(@image.id)
              expect(result[:thumbnail][:id]).to eq(@image.id)
              expect(result[:thumbnail][:originalUrl]).to eq(@image.file_url)
              expect(result[:thumbnail][:miniUrl]).to eq(@image.file_url(:mini))
              expect(result[:thumbnail][:thumbUrl]).to eq(@image.file_url(:thumb))
              expect(result[:thumbnail][:squareUrl]).to eq(@image.file_url(:square))
              expect(result[:thumbnail][:wideUrl]).to eq(@image.file_url(:wide))
            end
          end
        end
      end

      context "User is an admin" do
        it "should return 200 HTTP status with shop's informations updated" do
          # Prepare
          request.headers["HTTP_X_CLIENT_ID"] = @user_token

          # Execute
          patch :patch, params: { id: @shop.id,
                                  name: 'Nom boutique MAJ',
                                  email: 'maj-email@test.com',
                                  siret: '75409821800029',
                                  description: 'Description MAJ',
                                  mobileNumber: '0612345678',
                                  baseline: 'Baseline MAJ',
                                  facebookLink: 'https://www.facebook.com/dummy/test',
                                  instagramLink: 'https://www.instagram.com/dummy/test',
                                  websiteLink: 'https://www.dummy.com',
                                  address: {
                                    streetNumber: '52',
                                    route: 'Rue Georges Bonnac',
                                    locality: 'Bordeaux',
                                    country: 'France',
                                    postalCode: '33000',
                                    latitude: 44.84006,
                                    longitude: -0.58397,
                                    inseeCode: '33063'
                                  }
          }

          # Assert
          expect(response).to have_http_status(:ok)
          result = JSON.parse(response.body, symbolize_names: true)
          expect(result[:name]).to eq(response.request.params[:name])
          expect(result[:email]).to eq(response.request.params[:email])
          expect(result[:mobileNumber]).to eq(response.request.params[:mobileNumber])
          expect(result[:siret]).to eq(response.request.params[:siret])
          expect(result[:description]).to eq(response.request.params[:description])
          expect(result[:baseline]).to eq(response.request.params[:baseline])
          expect(result[:facebookLink]).to eq(response.request.params[:facebookLink])
          expect(result[:instagramLink]).to eq(response.request.params[:instagramLink])
          expect(result[:websiteLink]).to eq(response.request.params[:websiteLink])
          expect(result[:address]).not_to be_nil
          expect(result[:address][:streetNumber]).to eq(response.request.params[:address][:streetNumber])
          expect(result[:address][:route]).to eq(response.request.params[:address][:route])
          expect(result[:address][:locality]).to eq(response.request.params[:address][:locality])
          expect(result[:address][:country]).to eq(response.request.params[:address][:country])
          expect(result[:address][:postalCode]).to eq(response.request.params[:address][:postalCode])
          expect(result[:address][:latitude]).to eq(response.request.params[:address][:latitude])
          expect(result[:address][:longitude]).to eq(response.request.params[:address][:longitude])
          expect(result[:address][:inseeCode]).to eq(response.request.params[:address][:inseeCode])
        end

        context 'ImageUrl is set' do
          context 'For avatar' do
            it 'should 200 HTTP status with avatar image set' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, avatarUrl: 'http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg'}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:avatar]).not_to be_nil
            end
          end

          context 'For cover' do
            it 'should 200 HTTP status with cover image set' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, coverUrl: 'http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg'}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:cover]).not_to be_nil
            end
          end

          context 'For thumbnail' do
            it 'should 200 HTTP status with thumbnail image set' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, thumbnailUrl: 'http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg'}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:thumbnail]).not_to be_nil
            end
          end
        end

        context 'ImageId is set' do
          before(:each) do
            @image = create(:image)
          end

          context 'For avatar' do
            it 'should 200 HTTP status with profil image updated' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, avatarId: @image.id}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:avatar]).not_to be_nil
              expect(@shop.reload.profil.id).to eq(@image.id)
              expect(result[:avatar][:id]).to eq(@image.id)
              expect(result[:avatar][:originalUrl]).to eq(@image.file_url)
              expect(result[:avatar][:miniUrl]).to eq(@image.file_url(:mini))
              expect(result[:avatar][:thumbUrl]).to eq(@image.file_url(:thumb))
              expect(result[:avatar][:squareUrl]).to eq(@image.file_url(:square))
              expect(result[:avatar][:wideUrl]).to eq(@image.file_url(:wide))
            end
          end

          context 'For cover' do
            it 'should 200 HTTP status with cover image updated' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, coverId: @image.id}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:cover]).not_to be_nil
              expect(@shop.reload.featured.id).to eq(@image.id)
              expect(result[:cover][:id]).to eq(@image.id)
              expect(result[:cover][:originalUrl]).to eq(@image.file_url)
              expect(result[:cover][:miniUrl]).to eq(@image.file_url(:mini))
              expect(result[:cover][:thumbUrl]).to eq(@image.file_url(:thumb))
              expect(result[:cover][:squareUrl]).to eq(@image.file_url(:square))
              expect(result[:cover][:wideUrl]).to eq(@image.file_url(:wide))
            end
          end

          context 'For thumbnail' do
            it 'should 200 HTTP status with thumbnail image updated' do
              # Prepare
              request.headers["HTTP_X_CLIENT_ID"] = @user_token

              # Execute
              patch :patch, params: {id: @shop.id, thumbnailId: @image.id}

              # Assert
              expect(response).to have_http_status(:ok)
              result = JSON.parse(response.body, symbolize_names: true)
              expect(result[:thumbnail]).not_to be_nil
              expect(@shop.reload.thumbnail.id).to eq(@image.id)
              expect(result[:thumbnail][:id]).to eq(@image.id)
              expect(result[:thumbnail][:originalUrl]).to eq(@image.file_url)
              expect(result[:thumbnail][:miniUrl]).to eq(@image.file_url(:mini))
              expect(result[:thumbnail][:thumbUrl]).to eq(@image.file_url(:thumb))
              expect(result[:thumbnail][:squareUrl]).to eq(@image.file_url(:square))
              expect(result[:thumbnail][:wideUrl]).to eq(@image.file_url(:wide))
            end
          end
        end
      end
    end

    context "User is a shop owner but id of shop requested is not his shop" do
      it 'should return 403 HTTP status' do
        # Prepare
        user_shop_employee = create(:user, email: 'wrong-shop-employee@test.fr', shop_employee: create(:shop_employee))

        request.headers["HTTP_X_CLIENT_ID"] = generate_token(user_shop_employee)

        # Execute
        patch :patch, params: {id: @shop.id, name: "MAJ nom boutique"}

        # Assert
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
      end
    end

    context "Shop requested does not exist" do
      it 'should return 404 HTTP status' do
        # Prepare
        shop = create(:shop).destroy

        request.headers['HTTP_X_CLIENT_ID'] = @user_token

        # Execute
        patch :patch, params: {id: shop.id, description: 'Description MAJ'}

        # Assert
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{response.request.params[:id]}").to_h.to_json)
      end
    end
  
    context "User is a shop owner and request a shop which has been soft deleted" do
      it 'should return 403 HTTP status' do
        # Prepare
        shop = create(:shop)
        user = create(:user, email: 'shop_employee@test.fr', shop_employee: create(:shop_employee, shops: [shop]))
        shop.update(owner: user.shop_employee, deleted_at: Time.now)

        request.headers['HTTP_X_CLIENT_ID'] = generate_token(user)
        # Execute
        patch :patch, params: {id: shop.id, description: 'Description MAJ'}

        # Assert
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
      end
    end

    context "User token not given" do
      it 'should return 401 HTTP status' do
        # Prepare

        # Execute
        patch :patch, params: {id: @shop.id, name: 'Name MAJ'}

        # Assert
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
      end
    end

    context "User is not authorized" do
      it 'should return 403 HTTP status' do
        # Prepare
        request.headers['HTTP_X_CLIENT_ID'] = generate_token(create(:user, email: 'wrong-user-type@test.fr',
                                                                    customer: create(:customer)))

        # Execute
        patch :patch, params: {id: @shop.id, description: 'Description MAJ'}

        # Assert
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
      end
    end
  end

end