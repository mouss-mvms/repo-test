require "rails_helper"

RSpec.describe Api::V1::Citizens::ProductsController, type: :controller do
  describe "GET #index" do
    context "All ok" do
      let(:citizen) { create(:citizen) }
      let(:products) { create_list(:product, 17) }

      context "without :limit" do
        it "should return 200 HTTP status and handle pagination" do
          citizen.products << products
          citizen.save
          get :index, params: { id: citizen.id }
          expect(response).to have_http_status(:ok)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:products].count).to eq(16)
          expect(response_body[:page]).to eq(1)
          expect(response_body[:totalPages]).to eq(2)
          expect(response_body[:totalCount]).to eq(17)
        end
      end

      context "with :limit" do
        it "should return 200 HTTP status and handle pagination" do
          citizen.products << products
          citizen.save
          get :index, params: { id: citizen.id, limit: 4 }
          expect(response).to have_http_status(:ok)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:products].count).to eq(4)
          expect(response_body[:page]).to eq(1)
          expect(response_body[:totalPages]).to eq(5)
          expect(response_body[:totalCount]).to eq(17)
        end
      end

      context "with :sort_by" do
        context "created_at-asc" do
          it "should return 200 HTTP status and sort products ASC" do
            citizen.products << products
            citizen.save
            get :index, params: { id: citizen.id, sort_by: 'created_at-asc' }
            expect(response).to have_http_status(:ok)
            response_body = JSON.parse(response.body, symbolize_names: true)
            product_ids = response_body[:products].pluck(:id)
            product_ids.each_with_index do |id, index|
              break if id == product_ids.last
              expect(Product.find(id).created_at).to be <= Product.find(product_ids[index + 1]).created_at
            end
          end
        end

        context "created_at-desc" do
          it "should return 200 HTTP status and sort products DESC" do
            citizen.products << products
            citizen.save
            get :index, params: { id: citizen.id, sort_by: 'created_at-desc' }
            expect(response).to have_http_status(:ok)
            response_body = JSON.parse(response.body, symbolize_names: true)
            product_ids = response_body[:products].pluck(:id)
            product_ids.each_with_index do |id, index|
              break if id == product_ids.last
              expect(Product.find(id).created_at).to be >= Product.find(product_ids[index + 1]).created_at
            end
          end
        end
      end

      it "should return 304 HTTP status" do
        citizen.products << products
        citizen.save
        get :index, params: { id: citizen.id }
        expect(response).to have_http_status(:ok)

        etag = response.headers["ETag"]
        request.env["HTTP_IF_NONE_MATCH"] = etag
        get :index, params: { id: citizen.id }
        expect(response).to have_http_status(304)
      end
    end

    context "with invalid params" do
      context "id not a Numeric" do
        it "should returns 400 HTTP Status" do
          get :index, params: { id: "Xenomorph" }
          should respond_with(400)
        end
      end

      context "citizen doesn't exists" do
        it "should returns 404 HTTP Status" do
          User.where.not(citizen_id: nil).each do |user|
            user.citizen_id = nil
            user.save
          end
          Citizen.delete_all
          get :index, params: { id: 1 }
          should respond_with(404)
        end
      end
    end
  end

  describe "POST #create" do
    context "For a citizen's product" do
      context "All ok" do
        context "with imageIds" do
          it "should return 202 HTTP Status" do
            user_citizen = create(:citizen_user, email: "citizen0@ecity.fr")
            image = create(:image)
            category = create(:category, name: "Non Classée", slug: "non-classee")

            create_params = {
              name: "manteau MAC",
              citizenAdvice: "pouet ohfiuahia oihjafoih oiaijafiojf",
              shopId: create(:shop).id,
              variants: [
                {
                  imageIds: [image.id],
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                  ],
                },
              ],
            }

            request.headers["x-client-id"] = generate_token(user_citizen)
            job_id = "10aad2e35138aa982e0d848a"
            allow(Dao::Product).to receive(:create_async).and_return(job_id)
            expect(Dao::Product).to receive(:create_async)
            post :create, params: create_params
            should respond_with(202)
            expect(JSON.parse(response.body)["url"]).to eq(ENV["API_BASE_URL"] + api_v1_product_job_status_path(job_id))
          end
        end

        context "with imageUrls" do
          it "should return 202 HTTP Status" do
            user_citizen = create(:citizen_user, email: "citizen0@ecity.fr")
            image = create(:image)
            create(:category, name: "Non Classée", slug: "non-classee")

            create_params = {
              name: "manteau MAC",
              citizenAdvice: "pouet ohfiuahia oihjafoih oiaijafiojf",
              shopId: create(:shop).id,
              variants: [
                {
                  imageUrls: [image.file_url],
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                  ],
                },
              ],
            }

            request.headers["x-client-id"] = generate_token(user_citizen)
            job_id = "10aad2e35138aa982e0d848a"
            allow(Dao::Product).to receive(:create_async).and_return(job_id)
            expect(Dao::Product).to receive(:create_async)
            post :create, params: create_params
            should respond_with(202)
            expect(JSON.parse(response.body)["url"]).to eq(ENV["API_BASE_URL"] + api_v1_product_job_status_path(job_id))
          end
        end

        context "imageIds and imageUrls are both sent" do
          it "should return 202 HTTP status" do
            user_citizen = create(:citizen_user, email: "citizen0@ecity.fr")
            image = create(:image)
            create(:category, name: "Non Classée", slug: "non-classee")
            image = create(:image)
            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: create(:category).id,
              shopId: create(:shop).id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              citizenAdvice: "pouet",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageIds: [image.id],
                  imageUrls: ["1", "2", "3", "4", "5"],
                  isDefault: false,
                  goodDeal: {
                    startAt: "17/05/2021",
                    endAt: "18/06/2021",
                    discount: 20,
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                    {
                      value: "S",
                      name: "size",
                    },
                  ],
                },
              ],
            }
            request.headers["x-client-id"] = generate_token(user_citizen)
            job_id = "10aad2e35138aa982e0d848a"
            allow(Dao::Product).to receive(:create_async).and_return(job_id)
            expect(Dao::Product).to receive(:create_async)
            post :create, params: create_params
            should respond_with(202)
            expect(JSON.parse(response.body)["url"]).to eq(ENV["API_BASE_URL"] + api_v1_product_job_status_path(job_id))
          end
        end
      end

      context "Param incorrect" do
        let(:user_citizen) { create(:citizen_user, email: "citizen1@ecity.fr") }
        let(:image) { create(:image) }
        context "Shop id is missing" do
          it "should return 400 HTTP status" do
            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: create(:category).id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageIds: [image.id],
                  isDefault: false,
                  goodDeal: {
                    startAt: "17/05/2021",
                    endAt: "18/06/2021",
                    discount: 20,
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                    {
                      value: "S",
                      name: "size",
                    },
                  ],
                },
              ],
            }
            request.headers["x-client-id"] = generate_token(user_citizen)

            post :create, params: create_params

            should respond_with(400)
          end
        end

        context "citizenAdvice id is missing" do
          it "should return 400 HTTP status" do
            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: create(:category).id,
              shopId: create(:shop).id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageIds: [image.id],
                  isDefault: false,
                  goodDeal: {
                    startAt: "17/05/2021",
                    endAt: "18/06/2021",
                    discount: 20,
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                    {
                      value: "S",
                      name: "size",
                    },
                  ],
                },
              ],
            }
            request.headers["x-client-id"] = generate_token(user_citizen)

            post :create, params: create_params

            should respond_with(400)
          end
        end

        context "imageIds and imageUrls are missing" do
          it "should return 400 HTTP status" do
            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: create(:category).id,
              shopId: create(:shop).id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              citizenAdvice: "double pouet",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  isDefault: false,
                  goodDeal: {
                    startAt: "17/05/2021",
                    endAt: "18/06/2021",
                    discount: 20,
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                    {
                      value: "S",
                      name: "size",
                    },
                  ],
                },
              ],
            }
            request.headers["x-client-id"] = generate_token(user_citizen)

            post :create, params: create_params

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: imageIds or imageUrls").to_h.to_json)
          end
        end

        context "images count > 5" do
          context "imageIds count > 5" do
            it "should returns 400 HTTP status" do
              images = create_list(:image, 6)
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: create(:category).id,
                shopId: create(:shop).id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
                variants: [
                  {
                    basePrice: 379,
                    weight: 1,
                    quantity: 0,
                    imageIds: images.pluck(:id),
                    isDefault: false,
                    goodDeal: {
                      startAt: "17/05/2021",
                      endAt: "18/06/2021",
                      discount: 20,
                    },
                    characteristics: [
                      {
                        value: "coloris black",
                        name: "color",
                      },
                      {
                        value: "S",
                        name: "size",
                      },
                    ],
                  },
                ],
              }
              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
            end
          end

          context "imageUrls count > 5" do
            it "should returns 400 HTTP status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: create(:category).id,
                shopId: create(:shop).id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
                variants: [
                  {
                    basePrice: 379,
                    weight: 1,
                    quantity: 0,
                    imageUrls: ["1", "2", "3", "4", "5", "6"],
                    isDefault: false,
                    goodDeal: {
                      startAt: "17/05/2021",
                      endAt: "18/06/2021",
                      discount: 20,
                    },
                    characteristics: [
                      {
                        value: "coloris black",
                        name: "color",
                      },
                      {
                        value: "S",
                        name: "size",
                      },
                    ],
                  },
                ],
              }
              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
            end
          end
        end

        context "imageIds are not in db" do
          it "should return 404 HTTP status" do
            image_id = 0
            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: create(:category).id,
              shopId: create(:shop).id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              citizenAdvice: "pouet",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageIds: [image_id],
                  isDefault: false,
                  goodDeal: {
                    startAt: "17/05/2021",
                    endAt: "18/06/2021",
                    discount: 20,
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                    {
                      value: "S",
                      name: "size",
                    }
                  ]
                }
              ]
            }
            request.headers["x-client-id"] = generate_token(user_citizen)

            post :create, params: create_params
            should respond_with(404)
            expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Image with 'id'=#{image_id}").to_h.to_json)
          end
        end

        context "Category not found" do
          it "should return 404 HTTP Status" do
            create_params = {
              name: "manteau MAC",
              categoryId: 0,
              shopId: create(:shop).id,
              citizenAdvice: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageIds: [image.id],
                  isDefault: false,
                  goodDeal: {
                    startAt: "17/05/2021",
                    endAt: "18/06/2021",
                    discount: 20,
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                    {
                      value: "S",
                      name: "size",
                    },
                  ],
                },
              ],
            }

            request.headers["x-client-id"] = generate_token(user_citizen)

            post :create, params: create_params

            should respond_with(404)
          end
        end
      end

      context "Bad authentication" do
        context "x-client-id is missing" do
          let(:image) { create(:image) }
          it "should return 401 HTTP status" do
            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: create(:category).id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageIds: [image.id],
                  isDefault: false,
                  goodDeal: {
                    startAt: "17/05/2021",
                    endAt: "18/06/2021",
                    discount: 20,
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                    {
                      value: "S",
                      name: "size",
                    },
                  ],
                },
              ],
            }

            post :create, params: create_params

            should respond_with(401)
          end
        end

        context "User is not a citizen" do
          let(:image) { create(:image) }
          it "should return 403 HTTP status" do
            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: create(:category).id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageIds: [image.id],
                  isDefault: false,
                  goodDeal: {
                    startAt: "17/05/2021",
                    endAt: "18/06/2021",
                    discount: 20,
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color",
                    },
                    {
                      value: "S",
                      name: "size",
                    },
                  ],
                },
              ],
            }
            user_customer = create(:customer_user, email: "customer2@ecity.fr")

            request.headers["x-client-id"] = generate_token(user_customer)

            post :create, params: create_params

            should respond_with(403)
          end
        end
      end

      context "Bugs" do
        context "ae3xu0" do
          let(:user_citizen) { create(:citizen_user, email: "citizen3@ecity.fr") }
          let(:category_others_fresh_desserts) { create(:others_fresh_desserts) }
          it "should return HTTP status 400" do
            create_params = {
              name: "Air jordan api 3",
              description: "Chaussures trop bien",
              brand: "Chaussures trop bien",
              status: "online",
              sellerAdvice: "Taille petite, prendre une demi pointure au dessus",
              isService: false,
              citizenAdvice: "Produit trouvé un commercant trop sympa",
              categoryId: category_others_fresh_desserts.id,
              shopId: create(:shop).id,
              variants: [
                {
                  basePrice: 44.99,
                  weight: 0.56,
                  quantity: 9,
                  isDefault: true,
                  goodDeal: {
                    startAt: "20/07/2021",
                    endAt: "27/07/2021",
                    discount: 45,
                  },
                  characteristics: [
                    {
                      name: "color",
                      value: "Bleu",
                    },
                  ],
                },
              ],
              origin: "",
              allergens: "",
              composition: "Oeuf, sucre",
            }
            request.headers["x-client-id"] = generate_token(user_citizen)

            post :create, params: create_params

            should respond_with(400)
          end
        end
      end
    end
  end

  describe "PATCH #update" do
    context "All ok" do
      context "when image_urls" do
        it "should return 200 HTTP Status" do
          image_1 = create(:image)
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.samples << reference.sample
          reference.sample.images << image_1
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save
          expected_images_count = 2
          product_params = {
            name: "After MAJ",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
                imageUrls: ["https://img.myloview.fr/images/poop-vector-isolated-illustration-700-185627290.jpg"]
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          request.headers["x-client-id"] = generate_token(user_citizen)
          patch :update, params: product_params.merge(id: product.id)

          should respond_with(200)
          result = JSON.parse(response.body)
          product.reload
          expect(result["id"]).to eq(product.id)
          expect(result["name"]).to eq(product.name)
          expect(result["name"]).to eq(product_params[:name])
          variant_params_expected = product_params[:variants].find { |variant| variant[:id] == reference.id }
          variant_to_compare = result["variants"].find { |variant| variant["id"] == variant_params_expected[:id] }
          expect(variant_to_compare).not_to be_nil
          expect(variant_to_compare["basePrice"]).to eq(variant_params_expected[:basePrice])
          expect(variant_to_compare["imageUrls"].count).to eq(expected_images_count)
        end
      end

      context "when image_ids" do
        it "should return 200 HTTP Status" do
          image_1 = create(:image)
          image_2 = create(:image)
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.samples << reference.sample
          reference.sample.images << image_1
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save
          expected_images_count = 2
          product_params = {
            name: "After MAJ",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
                imageIds: [image_2.id]
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          request.headers["x-client-id"] = generate_token(user_citizen)
          patch :update, params: product_params.merge(id: product.id)

          should respond_with(200)
          result = JSON.parse(response.body)
          product.reload
          expect(result["id"]).to eq(product.id)
          expect(result["name"]).to eq(product.name)
          expect(result["name"]).to eq(product_params[:name])
          variant_params_expected = product_params[:variants].find { |variant| variant[:id] == reference.id }
          variant_to_compare = result["variants"].find { |variant| variant["id"] == variant_params_expected[:id] }
          expect(variant_to_compare).not_to be_nil
          expect(variant_to_compare["basePrice"]).to eq(variant_params_expected[:basePrice])
          expect(variant_to_compare["imageUrls"].count).to eq(expected_images_count)
        end
      end

      context "imageIds and imageUrls are both sent" do
        it "should return 200 HTTP Status" do
          image_1 = create(:image)
          image_2 = create(:image)
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.samples << reference.sample
          reference.sample.images << image_1
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save
          expected_images_count = 2
          product_params = {
            name: "After MAJ",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
                imageIds: [image_2.id],
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"]
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          request.headers["x-client-id"] = generate_token(user_citizen)
          patch :update, params: product_params.merge(id: product.id)

          should respond_with(200)
          result = JSON.parse(response.body)
          product.reload
          expect(result["id"]).to eq(product.id)
          expect(result["name"]).to eq(product.name)
          expect(result["name"]).to eq(product_params[:name])
          variant_params_expected = product_params[:variants].find { |variant| variant[:id] == reference.id }
          variant_to_compare = result["variants"].find { |variant| variant["id"] == variant_params_expected[:id] }
          expect(variant_to_compare).not_to be_nil
          expect(variant_to_compare["basePrice"]).to eq(variant_params_expected[:basePrice])
          expect(variant_to_compare["imageUrls"].count).to eq(expected_images_count)
          expect(variant_to_compare["imageUrls"]).to include(image_2.file_url)
        end
      end
    end

    context 'Bad Params' do
      context "When product'status is not submitted or refused" do
        it "should return 403 HTTP Status" do
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.name = "Before MAJ"
          product.status = "online"
          product.save
          product_params = {
            name: "After MAJ",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          request.headers["x-client-id"] = generate_token(user_citizen)
          patch :update, params: product_params.merge(id: product.id)

          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end

      context "Want to modify the product' status" do
        it "should return 403 HTTP Status" do
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save
          product_params = {
            name: "After MAJ",
            status: "online",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          request.headers["x-client-id"] = generate_token(user_citizen)
          patch :update, params: product_params.merge(id: product.id)

          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end

      context "Citizen is not the product's author" do
        it "should return 403 HTTP status" do
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save

          product_params = {
            name: "After MAJ",
            status: "online",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
              },
            ],
          }

          request.headers["x-client-id"] = generate_token(user_citizen)
          patch :update, params: product_params.merge(id: product.id)

          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{product.id} [WHERE \"citizen_products\".\"citizen_id\" = $1]").to_h.to_json)
        end
      end

      context "Can't find product wanted in citizen product" do
        it "should return 404 HTTP Status" do
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          reference2 = create(:reference, base_price: 500)
          product = reference.product
          product2 = reference2.product
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save
          product_params = {
            name: "After MAJ",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          request.headers["x-client-id"] = generate_token(user_citizen)
          patch :update, params: product_params.merge(id: product2.id)

          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{product2.id} [WHERE \"citizen_products\".\"citizen_id\" = $1]").to_h.to_json)
        end
      end

      context "imageIds are not in db" do
        it "should return 404 HTTP status" do
          image_id = 0
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save
          product_params = {
            name: "After MAJ",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
                imageIds: [image_id],
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          request.headers["x-client-id"] = generate_token(user_citizen)
          patch :update, params: product_params.merge(id: product.id)
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Image with 'id'=#{image_id}").to_h.to_json)
        end
      end
    end

    context "Bad authentification" do
      context "No user" do
        it "should return 401 HTTP Status" do
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save
          product_params = {
            name: "After MAJ",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          patch :update, params: product_params.merge(id: product.id)

          should respond_with(401)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "User is not a citizen" do
        it "should return 403 HTTP Status" do
          user_citizen = create(:citizen_user, email: "citizen783@ecity.fr")
          reference = create(:reference, base_price: 400)
          product = reference.product
          product.name = "Before MAJ"
          product.status = "submitted"
          product.save
          product_params = {
            name: "After MAJ",
            variants: [
              {
                id: reference.id,
                basePrice: 300,
              },
            ],
          }
          user_citizen.citizen.products << product
          user_citizen.citizen.save

          request.headers["x-client-id"] = generate_token(create(:shop_employee_user, email: "shop_employee7674@ecity.fr"))
          patch :update, params: product_params.merge(id: product.id)

          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end
end
