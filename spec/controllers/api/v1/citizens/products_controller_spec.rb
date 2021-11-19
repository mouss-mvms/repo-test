require "rails_helper"

RSpec.describe Api::V1::Citizens::ProductsController, type: :controller do
  describe "GET #index" do
    context "All ok" do
      let(:citizen) { create(:citizen) }
      let(:products) { create_list(:product, 5) }

      it "should return 200 HTTP status" do
        citizen.products << products
        citizen.save
        get :index, params: { id: citizen.id }
        expect(response).to have_http_status(:ok)

        response_body = JSON.parse(response.body)
        expect(response_body).to be_an_instance_of(Array)
        expect(response_body.count).to eq(5)

        product_ids = response_body.map { |p| p.symbolize_keys[:id] }
        expect(Product.where(id: product_ids).actives.to_a).to eq(products)
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
        it "should return 202 HTTP Status" do
          user_citizen = create(:citizen_user, email: "citizen0@ecity.fr")
          image = create(:image)
          category = create(:category, name: "Non Classée", slug: "non-classee")

          create_params = {
            name: "manteau MAC",
            citizenAdvice: "pouet",
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

        context "imageIds are missing" do
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
          end
        end

        context "imageIds count > 5" do
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
                  imageIds: [1, 2, 3, 4, 5, 6],
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

        context "Category not found" do
          it "should return 404 HTTP Status" do
            create_params = {
              name: "manteau MAC",
              categoryId: create(:category).id,
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
            Product.all.each do |p|
              p.category_id = nil
              p.save
            end
            Category.delete_all

            request.headers["x-client-id"] = generate_token(user_citizen)

            post :create, params: create_params

            should respond_with(404)
          end
        end

        context "Category is dry-fresh group" do
          let(:category) { create(:category, group: "dry-food") }
          let(:image) { create(:image) }
          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              category = create(:category)
              category.group = "dry-food"
              category.save

              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
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

              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
                composition: "Tissu",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is fresh-food group" do
          let(:category) { create(:category, group: "fresh-food") }
          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
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

              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
                composition: "Tissu",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is frozen-food group" do
          let(:category) { create(:category, group: "frozen-food") }
          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
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

              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
                composition: "Tissu",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is alcohol group" do
          let(:category) { create(:category, group: "alcohol") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
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

              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
                composition: "Tissu",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is cosmetic group" do
          let(:category) { create(:category, group: "cosmetic") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                citizenAdvice: "pouet",
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

              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                citizenAdvice: "pouet",
                sellerAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
                composition: "Tissu",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is food group" do
          let(:category) { create(:category, group: "food") }
          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
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

              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
                composition: "Tissu",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is clothing group" do
          let(:category) { create(:category, group: "clothing") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
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

              request.headers["x-client-id"] = generate_token(user_citizen)

              post :create, params: create_params

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              create_params = {
                name: "manteau MAC",
                slug: "manteau-mac",
                categoryId: category.id,
                brand: "3sixteen",
                status: "online",
                isService: true,
                sellerAdvice: "pouet",
                citizenAdvice: "pouet",
                shopId: create(:shop).id,
                origin: "France",
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
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin and composition is required")
            end
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
      it "should return 200 HTTP Status" do
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
      end
    end

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
