require "rails_helper"

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "PUT #update_offline" do
    context "All ok" do

      it "should return 200 HTTP Status with product updated" do
        provider = create(:api_provider, name: 'wynd')
        product = create(:product, api_provider_product: ApiProviderProduct.create(api_provider: provider, external_product_id: '13ut'))
        ref1 = create(:reference, product: product)
        ref2 = create(:reference, product: product)
        ref1_update_params = {
          id: ref1.id,
          basePrice: 20,
          weight: 13,
          quantity: 42,
          isDefault: false,
          imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
          goodDeal: {
            startAt: "17/05/2015",
            endAt: "18/06/2031",
            discount: 10,
          },
          characteristics: [
            {
              value: "coloris oaijf",
              name: "color",
            },
            {
              value: "beaucoup",
              name: "size",
            },
          ],
          provider: {
            name: provider.name,
            externalVariantId: 'rzsd12'
          }
        }
        ref2_update_params = {
          id: ref2.id,
          basePrice: 199.9,
          weight: 1111111.24,
          quantity: 412,
          isDefault: false,
          goodDeal: {
            startAt: "17/05/2011",
            endAt: "18/06/2011",
            discount: 99,
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
          provider: {
            name: provider.name,
            externalVariantId: 'rzsd14'
          }
        }
        new_ref_update_params = {
          basePrice: 19.9,
          weight: 0.24,
          quantity: 4,
          isDefault: true,
          imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
          provider: {
            name: provider.name,
            externalVariantId: 'rzsd34'
          }
        }
        update_params = {
          name: "Lot de 4 tasses à café style rétro AOC",
          categoryId: product.category_id,
          brand: "AOC",
          status: "online",
          isService: false,
          sellerAdvice: "Les tasses donneront du style à votre pause café !",
          description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
          variants: [
            new_ref_update_params,
            ref1_update_params,
            ref2_update_params,
          ],
          provider: {
            name: provider.name,
            externalProductId: 'tye65'
          }
        }

        put :update_offline, params: update_params.merge(id: product.id)

        should respond_with(200)
        result = JSON.parse(response.body)
        expect(result["id"]).to eq(product.id)
        expect(result["name"]).to eq(update_params[:name])
        expect(Product.find(result["id"]).name).to eq(update_params[:name])
        expect(result["category"]["id"]).to eq(update_params[:categoryId])
        expect(Category.find(result["category"]["id"]).slug).to eq(product.category.slug)
        expect(Category.find(result["category"]["id"]).name).to eq(product.category.name)
        expect(result["brand"]).to eq(update_params[:brand])
        expect(result["status"]).to eq(update_params[:status])
        expect(result["isService"]).to eq(update_params[:isService])
        expect(result["sellerAdvice"]).to eq(update_params[:sellerAdvice])
        expect(result["description"]).to eq(update_params[:description])
        expect(result["origin"]).to eq(update_params[:origin])
        expect(result["allergens"]).to eq(update_params[:allergens])
        expect(result["composition"]).to eq(update_params[:composition])
        expect(result["variants"].to_a.count).to eq(3)
      end
    end

    context "Incorrect Params" do
      context "Product not found" do
        it "should return 404 HTTP Status" do
          provider = create(:api_provider, name: 'wynd')

          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: create(:category).id,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              {
                basePrice: 19.9,
                weight: 0.24,
                quantity: 4,
                isDefault: true,
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
                provider: {
                  name: "wynd",
                  externalVariantId: 'Rt33'
                }
              },
            ],
            provider: {
              name: provider.name,
              externalProductId: 'tye65'
            }
          }
          Product.destroy_all

          put :update_offline, params: update_params.merge(id: 3)

          should respond_with(404)
        end
      end

      context "Category id is missing" do
        it "should return 400 HTTP status" do
          provider = create(:api_provider, name: 'wynd')

          product = create(:product)
          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: nil,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              {
                basePrice: 19.9,
                weight: 0.24,
                quantity: 4,
                isDefault: true,
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

          put :update_offline, params: update_params.merge(id: product.id)

          should respond_with(400)
        end
      end

      context "Category not found" do
        it "should return 404 HTTP status" do
          provider = create(:api_provider, name: 'wynd')

          product = create(:product)
          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: nil,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              {
                basePrice: 19.9,
                weight: 0.24,
                quantity: 4,
                isDefault: true,
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
                provider: {
                  name: "wynd",
                  externalVariantId: 'Rt33'
                }
              },
            ],
            provider: {
              name: provider.name,
              externalProductId: 'tye65'
            }
          }
          i = 1
          Category.all.each do |category|
            break if category.id != i
            i = i + 1
          end
          update_params[:categoryId] = i

          put :update_offline, params: update_params.merge(id: product.id)

          should respond_with(404)
        end
      end

      context "Category is dry-fresh group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "dry-food") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is fresh-food group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "fresh-food") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is frozen-food group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "frozen-food") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "Avec de la matière qui fait cale!",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is alcohol group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "alcohol") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is cosmetic group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "cosmetic") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is food group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "food") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is clothing group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "clothing") }

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            provider = create(:api_provider, name: 'wynd')

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
                  provider: {
                    name: "wynd",
                    externalVariantId: 'Rt33'
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }

            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end
      end

      context "In Provider" do
        context 'If provider is wynd and externalProductId is missing in product' do
          it 'should return 400 HTTP Status' do
            product = create(:product)

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
              provider: {
                name: "wynd"
              }
            }

            put :update_offline, params: update_params.merge(id: product.id)

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: provider.externalProductId').to_h.to_json)
          end
        end

      end

      context "If product doesn't have provider" do
        it 'should return 403 HTTP Status' do
          product = create(:product)
          provider = create(:api_provider, name: 'wynd')

          ref1 = create(:reference, product: product)
          ref2 = create(:reference, product: product)
          ref1_update_params = {
            id: ref1.id,
            basePrice: 20,
            weight: 13,
            quantity: 42,
            isDefault: false,
            externalVariantId: 'rzsd12',
            imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
            goodDeal: {
              startAt: "17/05/2015",
              endAt: "18/06/2031",
              discount: 10,
            },
            characteristics: [
              {
                value: "coloris oaijf",
                name: "color",
              },
              {
                value: "beaucoup",
                name: "size",
              },
            ],
            provider: {
              name: "wynd",
              externalVariantId: 'Rt33'
            }
          }
          ref2_update_params = {
            id: ref2.id,
            basePrice: 199.9,
            weight: 1111111.24,
            quantity: 412,
            isDefault: false,
            externalVariantId: 'rzsd42',
            goodDeal: {
              startAt: "17/05/2011",
              endAt: "18/06/2011",
              discount: 99,
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
            provider: {
              name: "wynd",
              externalVariantId: 'Rt34'
            }
          }
          new_ref_update_params = {
            basePrice: 19.9,
            weight: 0.24,
            quantity: 4,
            isDefault: true,
            imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
            externalVariantId: 'iuhzfiuh21',
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
            provider: {
              name: "wynd",
              externalVariantId: 'Rt35'
            }
          }

          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: product.category_id,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              new_ref_update_params,
              ref1_update_params,
              ref2_update_params,
            ]
          }

          put :update_offline, params: update_params.merge(id: product.id)

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end

      context "Product provider from request is not the same as the product provider saved" do
        it "should return 403 HTTP Status" do
          product = create(:product)
          provider = create(:api_provider, name: 'wynd')
          wrong_provider = create(:api_provider, name: 'wrong_provider')

          product.api_provider_product = ApiProviderProduct.create!(api_provider: provider, external_product_id: 'RED56')
          product.save
          ref1 = create(:reference, product: product)
          ref2 = create(:reference, product: product)
          ref1_update_params = {
            id: ref1.id,
            basePrice: 20,
            weight: 13,
            quantity: 42,
            isDefault: false,
            externalVariantId: 'rzsd12',
            imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
            goodDeal: {
              startAt: "17/05/2015",
              endAt: "18/06/2031",
              discount: 10,
            },
            characteristics: [
              {
                value: "coloris oaijf",
                name: "color",
              },
              {
                value: "beaucoup",
                name: "size",
              },
            ],
            provider: {
              name: "wynd",
              externalVariantId: 'Rt33'
            }
          }
          ref2_update_params = {
            id: ref2.id,
            basePrice: 199.9,
            weight: 1111111.24,
            quantity: 412,
            isDefault: false,
            externalVariantId: 'rzsd42',
            goodDeal: {
              startAt: "17/05/2011",
              endAt: "18/06/2011",
              discount: 99,
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
            provider: {
              name: "wynd",
              externalVariantId: 'Rt33'
            }
          }
          new_ref_update_params = {
            basePrice: 19.9,
            weight: 0.24,
            quantity: 4,
            isDefault: true,
            imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
            externalVariantId: 'iuhzfiuh21',
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
            provider: {
              name: "wynd",
              externalVariantId: 'Rt33'
            }
          }

          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: product.category_id,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              new_ref_update_params,
              ref1_update_params,
              ref2_update_params,
            ],
            provider: {
              name: wrong_provider.name,
              externalProductId: 'tye65'
            }
          }

          put :update_offline, params: update_params.merge(id: product.id)

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end

      context "Variant does not exist for this product" do
        it 'should return 404 HTTP Status' do
          product = create(:product)
          provider = create(:api_provider, name: 'wynd')
          product.api_provider_product = ApiProviderProduct.create(api_provider: provider, external_product_id: '34ui')
          product.save
          ref1 = create(:reference, product: product)
          ref2 = create(:reference)
          ref1_update_params = {
            id: ref1.id,
            basePrice: 20,
            weight: 13,
            quantity: 42,
            isDefault: false,
            externalVariantId: 'rzsd12',
            imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
            goodDeal: {
              startAt: "17/05/2015",
              endAt: "18/06/2031",
              discount: 10,
            },
            characteristics: [
              {
                value: "coloris oaijf",
                name: "color",
              },
              {
                value: "beaucoup",
                name: "size",
              },
            ],
            provider: {
              name: "wynd",
              externalVariantId: 'Rt33'
            }
          }
          ref2_update_params = {
            id: ref2.id,
            basePrice: 199.9,
            weight: 1111111.24,
            quantity: 412,
            isDefault: false,
            externalVariantId: 'rzsd42',
            goodDeal: {
              startAt: "17/05/2011",
              endAt: "18/06/2011",
              discount: 99,
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
            provider: {
              name: "wynd",
              externalVariantId: 'Rt33'
            }
          }
          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: product.category_id,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              ref1_update_params,
              ref2_update_params,
            ],
            provider: {
              name: provider.name,
              externalProductId: 'tye65'
            }
          }

          put :update_offline, params: update_params.merge(id: product.id)

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Reference with 'id'=#{ref2.id} [WHERE \"pr_references\".\"product_id\" = $1]").to_h.to_json)
        end
      end

      context 'In variant' do
        context 'Provider is missing' do
          it 'should return 400 HTTP Status' do
            provider = create(:api_provider, name: 'wynd')
            product = create(:product, api_provider_product: ApiProviderProduct.create(api_provider: provider, external_product_id: '13ut'))
            ref1 = create(:reference, product: product)
            ref2 = create(:reference, product: product)
            ref1_update_params = {
              id: ref1.id,
              basePrice: 20,
              weight: 13,
              quantity: 42,
              isDefault: false,
              imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
              goodDeal: {
                startAt: "17/05/2015",
                endAt: "18/06/2031",
                discount: 10,
              },
              characteristics: [
                {
                  value: "coloris oaijf",
                  name: "color",
                },
                {
                  value: "beaucoup",
                  name: "size",
                },
              ],
            }
            ref2_update_params = {
              id: ref2.id,
              basePrice: 199.9,
              weight: 1111111.24,
              quantity: 412,
              isDefault: false,
              goodDeal: {
                startAt: "17/05/2011",
                endAt: "18/06/2011",
                discount: 99,
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
              provider: {
                name: provider.name,
                externalVariantId: 'rzsd14'
              }
            }
            new_ref_update_params = {
              basePrice: 19.9,
              weight: 0.24,
              quantity: 4,
              isDefault: true,
              imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
              provider: {
                name: provider.name,
                externalVariantId: 'rzsd34'
              }
            }
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                new_ref_update_params,
                ref1_update_params,
                ref2_update_params,
              ],
              provider: {
                name: provider.name,
                externalProductId: 'tye65'
              }
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: variant.provider').to_h.to_json)
          end
        end
        context 'Provider' do
          context 'External variant id is missing in one variant' do
            it 'should return 400 HTTP Status' do
              provider = create(:api_provider, name: 'wynd')
              product = create(:product, api_provider_product: ApiProviderProduct.create(api_provider: provider, external_product_id: '13ut'))

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
                    imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                    provider: {
                      name: provider.name
                    }
                  },
                ],
                provider: {
                  name: 'wynd',
                  externalProductId: 'RT45'
                }
              }

              put :update_offline, params: create_params.merge(id: product.id)

              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: variant.provider.externalVariantId').to_h.to_json)
            end
          end

          context 'name is missing in one variant' do
            it 'should return 400 HTTP Status' do
              provider = create(:api_provider, name: 'wynd')
              product = create(:product, api_provider_product: ApiProviderProduct.create(api_provider: provider, external_product_id: '13ut'))

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
                    imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                    provider: {
                      externalVariantId: "ty78"
                    }
                  },
                ],
                provider: {
                  name: 'wynd',
                  externalProductId: '56ty'
                }
              }

              put :update_offline, params: create_params.merge(id: product.id)

              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: variant.provider.name').to_h.to_json)
            end
          end

          context "Provider name set is not the same as the product's provider" do
            it 'should return 403 HTTP Status' do
              provider = create(:api_provider, name: 'wynd')
              product = create(:product, api_provider_product: ApiProviderProduct.create(api_provider: provider, external_product_id: '13ut'))
              ref1 = create(:reference, product: product)
              ref2 = create(:reference, product: product)
              ref1_update_params = {
                id: ref1.id,
                basePrice: 20,
                weight: 13,
                quantity: 42,
                isDefault: false,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
                goodDeal: {
                  startAt: "17/05/2015",
                  endAt: "18/06/2031",
                  discount: 10,
                },
                characteristics: [
                  {
                    value: "coloris oaijf",
                    name: "color",
                  },
                  {
                    value: "beaucoup",
                    name: "size",
                  },
                ],
                provider: {
                  name: "#{provider.name}2",
                  externalVariantId: 'rzsd12'
                }
              }
              ref2_update_params = {
                id: ref2.id,
                basePrice: 199.9,
                weight: 1111111.24,
                quantity: 412,
                isDefault: false,
                goodDeal: {
                  startAt: "17/05/2011",
                  endAt: "18/06/2011",
                  discount: 99,
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
                provider: {
                  name: provider.name,
                  externalVariantId: 'rzsd14'
                }
              }
              new_ref_update_params = {
                basePrice: 19.9,
                weight: 0.24,
                quantity: 4,
                isDefault: true,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                provider: {
                  name: provider.name,
                  externalVariantId: 'rzsd34'
                }
              }
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: product.category_id,
                brand: "AOC",
                status: "online",
                isService: false,
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  new_ref_update_params,
                  ref1_update_params,
                  ref2_update_params,
                ],
                provider: {
                  name: provider.name,
                  externalProductId: 'tye65'
                }
              }

              put :update_offline, params: update_params.merge(id: product.id)

              expect(response).to have_http_status(:forbidden)
              expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
            end
          end
        end
      end

    end
  end

  describe "PUT #update" do
    context "For a citizen's product" do
      context "All ok" do
        it "should return 200 HTTP Status with product updated" do
          user_citizen = create(:citizen_user, email: "citizen3@ecity.fr")
          product = create(:product)
          user_citizen.citizen.products << product
          user_citizen.citizen.save
          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: product.category_id,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              {
                basePrice: 19.9,
                weight: 0.24,
                quantity: 4,
                isDefault: true,
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

          put :update, params: update_params.merge(id: product.id)

          should respond_with(200)
          result = JSON.parse(response.body)
          expect(result["id"]).to eq(product.id)
          expect(result["name"]).to eq(update_params[:name])
          expect(Product.find(result["id"]).name).to eq(update_params[:name])
          expect(result["category"]["id"]).to eq(update_params[:categoryId])
          expect(Category.find(result["category"]["id"]).slug).to eq(product.category.slug)
          expect(Category.find(result["category"]["id"]).name).to eq(product.category.name)
          expect(result["brand"]).to eq(update_params[:brand])
          expect(result["status"]).to eq(update_params[:status])
          expect(result["isService"]).to eq(update_params[:isService])
          expect(result["sellerAdvice"]).to eq(update_params[:sellerAdvice])
          expect(result["description"]).to eq(update_params[:description])
          expect(result["origin"]).to eq(update_params[:origin])
          expect(result["allergens"]).to eq(update_params[:allergens])
          expect(result["composition"]).to eq(update_params[:composition])
        end
      end

      context "Incorrect Params" do
        let(:user_citizen) { create(:citizen_user, email: "citizen2@ecity.fr") }
        context "Product not found" do
          it "should return 404 HTTP Status" do
            product = create(:product)
            user_citizen.citizen.products << product
            user_citizen.citizen.save
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: create(:category).id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
            Product.destroy_all

            request.headers["x-client-id"] = generate_token(user_citizen)

            put :update, params: update_params.merge(id: 3)

            should respond_with(404)
          end
        end

        context "Category id is missing" do
          it "should return 400 HTTP status" do
            product = create(:product)
            user_citizen.citizen.products << product
            user_citizen.citizen.save
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: nil,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            put :update, params: update_params.merge(id: product.id)

            should respond_with(400)
          end
        end

        context "Category not found" do
          it "should return 404 HTTP status" do
            product = create(:product)
            user_citizen.citizen.products << product
            user_citizen.citizen.save
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: nil,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
            i = 1
            Category.all.each do |category|
              break if category.id != i
              i = i + 1
            end
            update_params[:categoryId] = i

            put :update, params: update_params.merge(id: product.id)

            should respond_with(404)
          end
        end

        context "Category is dry-fresh group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "dry-food") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_citizen.citizen.products << product
              user_citizen.citizen.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is fresh-food group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "fresh-food") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_citizen.citizen.products << product
              user_citizen.citizen.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is frozen-food group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "frozen-food") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_citizen.citizen.products << product
              user_citizen.citizen.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is alcohol group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "alcohol") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_citizen.citizen.products << product
              user_citizen.citizen.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is cosmetic group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "cosmetic") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_citizen.citizen.products << product
              user_citizen.citizen.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is food group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "food") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_citizen.citizen.products << product
              user_citizen.citizen.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is clothing group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "clothing") }

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end
        end
      end

      context "Bad authentication" do
        context "x-client-id is missing" do
          it "should return 401 HTTP Status" do
            product = create(:product)
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            put :update, params: update_params.merge(id: product.id)

            should respond_with(401)
          end
        end

        context "User not found" do
          it "should return 403 HTTP Status" do
            user_citizen = create(:citizen_user, email: "citizen3@ecity.fr")
            product = create(:product)
            user_citizen.citizen.products << product
            user_citizen.citizen.save

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
            User.delete_all

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end

        context "User is not a citizen" do
          it "should return 403 HTTP Status" do
            user_citizen = create(:citizen_user, email: "citizen4@ecity.fr")
            product = create(:product)
            user_citizen.citizen.products << product
            user_citizen.citizen.save

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            user_shop_employee = create(:shop_employee_user, email: "shop.employee2@ecity.fr")
            request.headers["x-client-id"] = generate_token(user_shop_employee)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end

        context "User is a citizen but not the owner of the product" do
          it "should return 403 HTTP Status" do
            user_citizen = create(:citizen_user, email: "citizen5@ecity.fr")
            product = create(:product)
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end
      end
    end

    context "For a shop's product" do
      context "All ok" do
        it "should return 200 HTTP Status with product updated" do
          user_shop_employee = create(:shop_employee_user, email: "shop.employee3@ecity.fr")
          product = create(:product)
          ref1 = create(:reference, product: product)
          ref2 = create(:reference, product: product)
          ref3 = create(:reference, product: product)
          ref1_update_params = {
            id: ref1.id,
            basePrice: 20,
            weight: 13,
            quantity: 42,
            isDefault: false,
            imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
            goodDeal: {
              startAt: "17/05/2015",
              endAt: "18/06/2031",
              discount: 10,
            },
            characteristics: [
              {
                value: "coloris oaijf",
                name: "color",
              },
              {
                value: "beaucoup",
                name: "size",
              },
            ],
          }
          ref2_update_params = {
            id: ref2.id,
            basePrice: 199.9,
            weight: 1111111.24,
            quantity: 412,
            isDefault: false,
            goodDeal: {
              startAt: "17/05/2011",
              endAt: "18/06/2011",
              discount: 99,
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
          }
          new_ref_update_params = {
            basePrice: 19.9,
            weight: 0.24,
            quantity: 4,
            isDefault: true,
            imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
          }
          user_shop_employee.shop_employee.shops << product.shop
          user_shop_employee.shop_employee.save
          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: product.category_id,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              new_ref_update_params,
              ref1_update_params,
              ref2_update_params,
            ]
          }

          request.headers["x-client-id"] = generate_token(user_shop_employee)

          put :update, params: update_params.merge(id: product.id)

          should respond_with(200)
          result = JSON.parse(response.body)
          expect(result["id"]).to eq(product.id)
          expect(result["name"]).to eq(update_params[:name])
          expect(Product.find(result["id"]).name).to eq(update_params[:name])
          expect(result["category"]["id"]).to eq(update_params[:categoryId])
          expect(Category.find(result["category"]["id"]).slug).to eq(product.category.slug)
          expect(Category.find(result["category"]["id"]).name).to eq(product.category.name)
          expect(result["brand"]).to eq(update_params[:brand])
          expect(result["status"]).to eq(update_params[:status])
          expect(result["isService"]).to eq(update_params[:isService])
          expect(result["sellerAdvice"]).to eq(update_params[:sellerAdvice])
          expect(result["description"]).to eq(update_params[:description])
          expect(result["origin"]).to eq(update_params[:origin])
          expect(result["allergens"]).to eq(update_params[:allergens])
          expect(result["composition"]).to eq(update_params[:composition])
          expect(product.references.count).to eq(3)

          ref1_updated = Reference.where(id: ref1.id).first
          expect(ref1_updated).to_not be_nil
          expect(ref1_updated.base_price).to eq(ref1_update_params[:basePrice])
          expect(ref1_updated.weight).to eq(ref1_update_params[:weight])
          expect(ref1_updated.quantity).to eq(ref1_update_params[:quantity])
          expect(ref1_updated.sample.default).to eq(ref1_update_params[:isDefault])
          expect(ref1_updated.sample.images).not_to be_empty
          expect(ref1_updated.good_deal.starts_at.strftime("%d/%m/%Y")).to eq(ref1_update_params[:goodDeal][:startAt])
          expect(ref1_updated.good_deal.discount).to eq(ref1_update_params[:goodDeal][:discount])
          expect(ref1_updated.size.name).to eq(ref1_update_params[:characteristics].last[:value])
          expect(ref1_updated.color.name).to eq(ref1_update_params[:characteristics].first[:value])

          ref2_updated = Reference.where(id: ref2.id).first
          expect(ref2_updated).to_not be_nil
          expect(ref2_updated.base_price).to eq(ref2_update_params[:basePrice])
          expect(ref2_updated.weight).to eq(ref2_update_params[:weight])
          expect(ref2_updated.quantity).to eq(ref2_update_params[:quantity])
          expect(ref2_updated.sample.default).to eq(ref2_update_params[:isDefault])
          expect(ref2_updated.sample.images).to be_empty
          expect(ref2_updated.good_deal.starts_at.strftime("%d/%m/%Y")).to eq(ref2_update_params[:goodDeal][:startAt])
          expect(ref2_updated.good_deal.discount).to eq(ref2_update_params[:goodDeal][:discount])
          expect(ref2_updated.size.name).to eq(ref2_update_params[:characteristics].last[:value])
          expect(ref2_updated.color.name).to eq(ref2_update_params[:characteristics].first[:value])

          new_variant = Reference.where(product_id: product.id).where.not(id: [ref1.id, ref2.id]).first
          expect(new_variant).to_not be_nil
          expect(new_variant.base_price).to eq(new_ref_update_params[:basePrice])
          expect(new_variant.weight).to eq(new_ref_update_params[:weight])
          expect(new_variant.quantity).to eq(new_ref_update_params[:quantity])
          expect(new_variant.sample.default).to eq(new_ref_update_params[:isDefault])
          expect(new_variant.sample.images).not_to be_empty
          expect(new_variant.good_deal.starts_at.strftime("%d/%m/%Y")).to eq(new_ref_update_params[:goodDeal][:startAt])
          expect(new_variant.good_deal.discount).to eq(new_ref_update_params[:goodDeal][:discount])
          expect(new_variant.size.name).to eq(new_ref_update_params[:characteristics].last[:value])
          expect(new_variant.color.name).to eq(new_ref_update_params[:characteristics].first[:value])
          expect(Reference.where(id: ref3.id).first).to be_nil
        end
      end

      context "Bad authentication" do
        context "x-client-id is missing" do
          it "should return 401 HTTP Status" do
            product = create(:product)
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            put :update, params: update_params.merge(id: product.id)

            should respond_with(401)
          end
        end

        context "User not found" do
          it "should return 403 HTTP Status" do
            user_shop_employee = create(:shop_employee_user, email: "shop.employee10@ecity.fr")
            product = create(:product)
            user_shop_employee.shop_employee.shops << product.shop
            user_shop_employee.shop_employee.save

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            request.headers["x-client-id"] = generate_token(user_shop_employee)
            User.delete_all

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end

        context "User is not a shop employee" do
          it "should return 403 HTTP Status" do
            user_shop_employee = create(:shop_employee_user, email: "shop.employee90@ecity.fr")
            product = create(:product)
            user_shop_employee.shop_employee.shops << product.shop
            user_shop_employee.shop_employee.save
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            user_citizen = create(:citizen_user, email: "citizen756@ecity.fr")
            request.headers["x-client-id"] = generate_token(user_citizen)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end

        context "User is a shop employee but the shop is not the owner of the product" do
          it "should return 403 HTTP Status" do
            user_shop_employee = create(:shop_employee_user, email: "shop.employee4@ecity.fr")
            product = create(:product)
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end
      end

      context "Incorrect Params" do
        let(:user_shop_employee) { create(:shop_employee_user, email: "shop.employee5@ecity.fr") }

        context "Product not found" do
          it "should return 404 HTTP Status" do
            product = create(:product)
            user_shop_employee.shop_employee.shops << product.shop
            user_shop_employee.shop_employee.save
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: create(:category).id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
            Product.destroy_all

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            put :update, params: update_params.merge(id: 3)

            should respond_with(404)
          end
        end

        context "Category id is missing" do
          it "should return 400 HTTP status" do
            product = create(:product)
            user_shop_employee.shop_employee.shops << product.shop
            user_shop_employee.shop_employee.save
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: nil,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
            request.headers["x-client-id"] = generate_token(user_shop_employee)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(400)
          end
        end

        context "Category not found" do
          it "should return 404 HTTP status" do
            product = create(:product)
            user_shop_employee.shop_employee.shops << product.shop
            user_shop_employee.shop_employee.save
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: 4,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
            request.headers["x-client-id"] = generate_token(user_shop_employee)
            i = 1
            Category.all.each do |category|
              break if category.id != i
              i = i + 1
            end
            update_params[:categoryId] = i

            put :update, params: update_params.merge(id: product.id)

            should respond_with(404)
          end
        end

        context "Category is dry-fresh group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "dry-food") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is fresh-food group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "fresh-food") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is frozen-food group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "frozen-food") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is alcohol group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "alcohol") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is cosmetic group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "cosmetic") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is food group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "food") }

          context "Origin of product is missing" do
            it "should return 400 HTTP Status" do
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("origin is required")
            end
          end

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end

          context "Allergens of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                composition: "Avec de la matière",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("allergens is required")
            end
          end
        end

        context "Category is clothing group" do
          let(:product) { create(:product) }
          let(:category) { create(:category, group: "clothing") }

          context "Composition of product is missing" do
            it "should return 400 HTTP Status" do
              update_params = {
                name: "Lot de 4 tasses à café style rétro AOC",
                categoryId: category.id,
                brand: "AOC",
                status: "online",
                isService: false,
                origin: "France",
                sellerAdvice: "Les tasses donneront du style à votre pause café !",
                description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
                variants: [
                  {
                    basePrice: 19.9,
                    weight: 0.24,
                    quantity: 4,
                    isDefault: true,
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
              user_shop_employee.shop_employee.shops << product.shop
              user_shop_employee.shop_employee.save

              request.headers["x-client-id"] = generate_token(user_shop_employee)

              put :update, params: update_params.merge(id: product.id)

              should respond_with(400)
              result = JSON.parse(response.body)
              expect(result["detail"]).to eq("composition is required")
            end
          end
        end
      end
    end
  end

  describe "PATCH #patch" do
    context "All ok" do
      context "when request comme from over provider" do
        it 'should return 200 HTTP status code with the updated product' do
          reference = create(:reference)
          provider = create(:api_provider, name: 'wynd')
          product = reference.product
          product_params = {
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
                quantity: 4,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
                isDefault: false,
                goodDeal: {
                  startAt: "17/05/2021",
                  endAt: "18/06/2021",
                  discount: 20,
                },
                characteristics: [
                  {
                    value: "coloris red",
                    name: "color",
                  },
                  {
                    value: "42",
                    name: "size",
                  },
                ],
                provider: {
                  name: provider.name,
                  externalVariantId: '545ti'
                }
              },
              {
                id: reference.id,
                basePrice: 379,
                weight: 1,
                quantity: 4,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                provider: {
                  name: provider.name,
                  externalVariantId: '56ti'
                }
              }
            ],
            provider: {
              name: provider.name,
              externalProductId: 'tye65'
            }
          }
          product.api_provider_product = ApiProviderProduct.create!(api_provider: provider, external_product_id: 'RED56')
          product.save

          patch :patch, params: product_params.merge(id: product.id)
          should respond_with(200)

          result = JSON.parse(response.body)
          expect(result["name"]).to eq(product_params[:name])
          expect(Product.find(result["id"]).name).to eq(product_params[:name])
          expect(result["category"]["id"]).to eq(product_params[:categoryId])
          expect(Category.find(result["category"]["id"]).name).to eq(product.category.name)
          expect(result["brand"]).to eq(product_params[:brand])
          expect(result["status"]).to eq(product_params[:status])
          expect(result["isService"]).to eq(product_params[:isService])
          expect(result["sellerAdvice"]).to eq(product_params[:sellerAdvice])
          expect(result["description"]).to eq(product_params[:description])
          expect(result["origin"]).to eq(product_params[:origin])
          expect(result["allergens"]).to eq(product_params[:allergens])
          expect(result["composition"]).to eq(product_params[:composition])
          expect(product.reload.api_provider_product.external_product_id).to eq(product_params[:provider][:externalProductId])
        end
      end
    end

    context 'Bad params' do
      context "Missing params on variant without id" do
        it "should respond with HTTP STATUS 400 - PARAMS MISSING" do
          user_shop_employee = create(:shop_employee_user, email: "shop.employee3@ecity.fr")
          reference = create(:reference)
          product = reference.product
          product_params = {
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
                quantity: 0,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
              {
                id: reference.id,
                basePrice: 379,
                weight: 1,
                quantity: 0,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
          user_shop_employee.shop_employee.shops << product.shop
          user_shop_employee.shop_employee.save
          request.headers["x-client-id"] = generate_token(user_shop_employee)
          patch :patch, params: product_params.merge(id: product.id)
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: weight").to_h.to_json)
        end
      end

      context "Product not found" do
        it "should return 404 HTTP Status" do
          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: create(:category).id,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              {
                basePrice: 19.9,
                weight: 0.24,
                quantity: 4,
                isDefault: true,
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
          Product.destroy_all

          patch :patch, params: update_params.merge(id: 12)

          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Product with 'id'=12").to_h.to_json)
        end
      end

      context "Category not found" do
        it "should return 404 HTTP status" do
          product = create(:product)
          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            categoryId: nil,
            brand: "AOC",
            status: "online",
            isService: false,
            sellerAdvice: "Les tasses donneront du style à votre pause café !",
            description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
            variants: [
              {
                basePrice: 19.9,
                weight: 0.24,
                quantity: 4,
                isDefault: true,
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
          i = 1
          Category.all.each do |category|
            break if category.id != i
            i = i + 1
          end
          update_params[:categoryId] = i

          patch :patch, params: update_params.merge(id: product.id)

          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Category with 'id'=1").to_h.to_json)
        end
      end

      context "Category is dry-fresh group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "dry-food") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("origin is required").to_h.to_json)
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("composition is required").to_h.to_json)
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("allergens is required").to_h.to_json)
          end
        end
      end

      context "Category is fresh-food group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "fresh-food") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("origin is required").to_h.to_json)
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("composition is required").to_h.to_json)
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("allergens is required").to_h.to_json)
          end
        end
      end

      context "Category is frozen-food group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "frozen-food") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "Avec de la xxxxx",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("origin is required").to_h.to_json)
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("composition is required").to_h.to_json)
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("allergens is required").to_h.to_json)
          end
        end
      end

      context "Category is alcohol group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "alcohol") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "AJhgjhgfsdfgjzehfgd",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("origin is required").to_h.to_json)
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("composition is required").to_h.to_json)
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("allergens is required").to_h.to_json)
          end
        end
      end

      context "Category is cosmetic group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "cosmetic") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "jhqsgdjhqegdjhegd",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("origin is required").to_h.to_json)
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("composition is required").to_h.to_json)
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("allergens is required").to_h.to_json)
          end
        end
      end

      context "Category is food group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "food") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              composition: "jhqsgdjq",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("origin is required").to_h.to_json)
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("composition is required").to_h.to_json)
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              composition: "Avec de la matière",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("allergens is required").to_h.to_json)
          end
        end
      end

      context "Category is clothing group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "clothing") }

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: category.id,
              brand: "AOC",
              status: "online",
              isService: false,
              origin: "France",
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("composition is required").to_h.to_json)
          end
        end
      end

      context "In Provider" do
        context 'If provider is wynd and externalProductId is missing in product' do
          it 'should return 400 HTTP Status' do
            product = create(:product)

            update_params = {
              name: "Lot de 4 tasses à café style rétro AOC",
              categoryId: product.category_id,
              brand: "AOC",
              status: "online",
              isService: false,
              sellerAdvice: "Les tasses donneront du style à votre pause café !",
              description: "Lot de 4 tasses à café rétro chic en porcelaine. 4 tasses et 4 sous-tasses de 4 couleurs différentes.",
              variants: [
                {
                  basePrice: 19.9,
                  weight: 0.24,
                  quantity: 4,
                  isDefault: true,
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
              provider: {
                name: "wynd"
              }
            }

            patch :patch, params: update_params.merge(id: product.id)

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: provider.externalProductId').to_h.to_json)
          end
        end

      end

      context "variant dont belongs to product" do
        it 'should return 404 HTTP Status' do
          shop = create(:shop)
          product = create(:product)
          ref1 = create(:reference)
          ref2 = create(:reference)
          product.references << ref2
          shop.products << product

          provider = create(:api_provider, name: 'wynd')
          product.api_provider_product = ApiProviderProduct.create!(api_provider: provider, external_product_id: 'RED56')
          product.save

          product_params = {
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
                id: ref1.id,
                basePrice: 379,
                weight: 1,
                quantity: 0,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
            provider: {
              name: provider.name,
              externalProductId: 'tye65'
            }
          }

          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save

          shop.owner = user_shop_employee.shop_employee
          shop.save

          request.headers["x-client-id"] = generate_token(user_shop_employee)

          patch :patch, params: product_params.merge(id: product.id)

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Reference with 'id'=#{ref1.id} [WHERE \"pr_references\".\"product_id\" = $1]").to_h.to_json)
        end
      end

      context "If product doesn't have provider" do
        it 'should return 403 HTTP Status' do
          product = create(:product)
          provider = create(:api_provider, name: 'wynd')

          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            provider: {
              name: provider.name,
              externalProductId: 'tye65'
            }
          }

          patch :patch, params: update_params.merge(id: product.id)

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end

      context "Product provider from request is not the same as the product provider saved" do
        it "should return 403 HTTP Status" do
          product = create(:product)
          provider = create(:api_provider, name: 'wynd')
          wrong_provider = create(:api_provider, name: 'wrong_provider')

          product.api_provider_product = ApiProviderProduct.create!(api_provider: provider, external_product_id: 'RED56')
          product.save

          update_params = {
            name: "Lot de 4 tasses à café style rétro AOC",
            provider: {
              name: wrong_provider.name,
              externalProductId: 'tye65'
            }
          }

          patch :patch, params: update_params.merge(id: product.id)

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end

  describe "GET #show" do
    context "All ok" do
      it "should return 200 HTTP Status with product" do
        product = create(:product)

        get :show, params: { id: product.id }

        should respond_with(200)
        result = JSON.parse(response.body)
        expect(result["id"]).to eq(product.id)
        expect(result["name"]).to eq(product.name)
        expect(result["slug"]).to eq(product.slug)
      end

      it "should return 304 HTTP Status with product" do
        product = create(:product)
        get :show, params: { id: product.id }
        should respond_with(200)

        etag = response.headers["ETag"]
        request.env["HTTP_IF_NONE_MATCH"] = etag
        get :show, params: { id: product.id }
        should respond_with(304)
      end
    end

    context "Product not found" do
      it "should return 404 HTTP status" do
        Product.destroy_all

        get :show, params: { id: 4 }

        should respond_with(404)
      end
    end
  end

  describe "POST #create_offline" do
    context "All ok" do
      it "should return 201 HTTP Status" do
        provider = create(:api_provider, name: 'wynd')
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
              imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
              provider: {
                name: provider.name,
                externalVariantId: "tyh46"
              }
            },
          ],
          provider: {
            name: provider.name,
            externalProductId: '56ty'
          }
        }
        post :create_offline, params: create_params
        should respond_with(201)
        result = JSON.parse(response.body)
        product = Product.find(result["id"])
        expect(product).to_not be_nil
        expect(result["name"]).to eq(create_params[:name])
        expect(Product.find(result["id"]).name).to eq(create_params[:name])
        expect(result["category"]["id"]).to eq(create_params[:categoryId])
        expect(Category.find(result["category"]["id"]).slug).to eq(product.category.slug)
        expect(Category.find(result["category"]["id"]).name).to eq(product.category.name)
        expect(result["brand"]).to eq(create_params[:brand])
        expect(result["status"]).to eq(product.status)
        expect(result["isService"]).to eq(create_params[:isService])
        expect(result["sellerAdvice"]).to eq(create_params[:sellerAdvice])
        expect(result["description"]).to eq(create_params[:description])
        expect(result["origin"]).to eq(create_params[:origin])
        expect(result["allergens"]).to eq(create_params[:allergens])
        expect(result["composition"]).to eq(create_params[:composition])
        expect(product.references.count).to eq(1)
      end
    end

    context "Param incorrect" do
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
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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

          post :create_offline, params: create_params

          should respond_with(400)
        end
      end

      context "Shop not found" do
        it "should return 404 HTTP status" do
          provider = create(:api_provider, name: 'wynd')

          create_params = {
            name: "manteau MAC",
            slug: "manteau-mac",
            categoryId: create(:category).id,
            brand: "3sixteen",
            status: "online",
            isService: true,
            sellerAdvice: "pouet",
            shopId: 0,
            description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
            variants: [
              {
                basePrice: 379,
                weight: 1,
                quantity: 0,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                provider: {
                  name: provider.name,
                  externalVariantId: "tyh46"
                }
              },
            ],
            provider: {
              name: 'wynd',
              externalProductId: '56ty'
            }
          }

          post :create_offline, params: create_params

          should respond_with(404)
        end
      end

      context "Category id is missing" do
        it "should return 400 HTTP status" do
          provider = create(:api_provider, name: 'wynd')

          create_params = {
            name: "manteau MAC",
            slug: "manteau-mac",
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
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                provider: {
                  name: provider.name,
                  externalVariantId: "tyh46"
                }
              },
            ],
          }

          post :create_offline, params: create_params

          should respond_with(400)
        end
      end

      context "Category not found" do
        it "should return 404 HTTP Status" do
          provider = create(:api_provider, name: 'wynd')

          create_params = {
            name: "manteau MAC",
            slug: "manteau-mac",
            brand: "3sixteen",
            status: "online",
            categoryId: 0,
            isService: true,
            sellerAdvice: "pouet",
            shopId: create(:shop).id,
            description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
            variants: [
              {
                basePrice: 379,
                weight: 1,
                quantity: 0,
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                provider: {
                  name: provider.name,
                  externalVariantId: "tyh46"
                }
              },
            ],
            provider: {
              name: 'wynd',
              externalProductId: '56ty'
            }
          }

          post :create_offline, params: create_params

          should respond_with(404)
        end
      end

      context "Category is dry-fresh group" do
        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "dry-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              composition: "jdfgsjegd",
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }
                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "dry-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }
                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "dry-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              composition: "Tissu",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }
                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is fresh-food group" do
        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "fresh-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              composition: "qjsdghq",
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "fresh-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "fresh-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              composition: "Tissu",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is frozen-food group" do
        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "frozen-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              composition: "kshdgcjhsdg",
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "frozen-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "frozen-food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              composition: "Tissu",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is alcohol group" do
        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "alcohol"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              composition: "hjdsgcj",
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }
                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "alcohol"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "alcohol"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              composition: "Tissu",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is cosmetic group" do
        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "cosmetic"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              composition: "jhsgdhjqgdg",
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "cosmetic"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "cosmetic"
            category.save

            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              composition: "Tissu",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is food group" do
        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "food"
            category.save

            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              composition: "jhqgsjgfqs",
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "food"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              composition: "Tissu",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is clothing group" do

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "clothing"
            category.save
            provider = create(:api_provider, name: 'wynd')

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
              brand: "3sixteen",
              status: "online",
              isService: true,
              sellerAdvice: "pouet",
              shopId: create(:shop).id,
              origin: "France",
              description: "Manteau type Macintosh en tissu 100% coton déperlant sans traitement. Les fibres de coton à fibres extra longues (ELS) sont tissées de manière incroyablement dense - rien de plus. Les fibres ELS sont difficiles à trouver - seulement 2% du coton mondial peut fournir des fibres qui répondent à cette norme.Lorsque le tissu est mouillé, ces fils se dilatent et créent une barrière impénétrable contre l'eau. Le tissu à la sensation au touché, le drapé et la respirabilité du coton avec les propriétés techniques d'un tissu synthétique. Le manteau est doté d'une demi-doublure à imprimé floral réalisée au tampon à la main dans la plus pure tradition indienne.2 coloris: TAN ou BLACK",
              variants: [
                {
                  basePrice: 379,
                  weight: 1,
                  quantity: 0,
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }

                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("composition is required")
          end
        end
      end

      context 'Provider is missing' do
        it 'should return a 400 HTTP Status' do
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
                imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
            ]
          }

          post :create_offline, params: create_params

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: provider').to_h.to_json)
        end
      end

      context 'In provider' do
        context 'Provider is wynd and externalProductId is missing' do
          it 'should return 400 HTTP Status' do
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
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
              provider: {
                name: 'wynd'
              }
            }

            post :create_offline, params: create_params

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: provider.externalProductId').to_h.to_json)

          end
        end
      end

      context 'In variant' do
        context 'Provider is missing' do
          it 'should return 400 HTTP Status' do
            provider = create(:api_provider, name: 'wynd')

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
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  ]
                },
              ],
              provider: {
                name: 'wynd',
                externalProductId: 'RT45'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: variant.provider').to_h.to_json)
          end
        end
        context "Provider is not the same as the provider's product" do
          it 'should return 403 HTTP Status' do
            provider = create(:api_provider, name: 'wynd')
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
                  imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                  provider: {
                    name: "#{provider.name}2",
                    externalVariantId: "tyh46"
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: '56ty'
              }
            }
            post :create_offline, params: create_params

            expect(response).to have_http_status(:forbidden)
            expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          end
        end
        context 'Provider' do
          context 'External variant id is missing in one variant' do
            it 'should return 400 HTTP Status' do
              provider = create(:api_provider, name: 'wynd')

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
                    imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                    provider: {
                      name: provider.name
                    }
                  },
                ],
                provider: {
                  name: 'wynd',
                  externalProductId: 'RT45'
                }
              }

              post :create_offline, params: create_params

              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: variant.provider.externalVariantId').to_h.to_json)
            end
          end

          context 'name is missing in one variant' do
            it 'should return 400 HTTP Status' do

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
                    imageUrls: ["https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg"],
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
                    provider: {
                      externalVariantId: "ty78"
                    }
                  },
                ],
                provider: {
                  name: 'wynd',
                  externalProductId: '56ty'
                }
              }

              post :create_offline, params: create_params

              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: variant.provider.name').to_h.to_json)
            end
          end
        end
        context 'when image url format is incorrect' do
          it 'should return 422 HTTP Status' do
            provider = create(:api_provider, name: 'wynd')
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
                  imageUrls: ["https://fr.wikipedia.org/wiki/Emma_Watson#/media/Fichier:Emma_Watson_2013.jpg"],
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
                  provider: {
                    name: provider.name,
                    externalVariantId: "tyh46"
                  }
                },
              ],
              provider: {
                name: provider.name,
                externalProductId: '56ty'
              }
            }
            post :create_offline, params: create_params
            expect(response).to have_http_status(422)
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "For a citizen's product" do
      context "All ok" do
        it "should return 204 HTTP status" do
          user_citizen = create(:citizen_user, email: "citizen6@ecity.fr")
          product = create(:product)
          user_citizen.citizen.products << product
          user_citizen.citizen.save
          request.headers["x-client-id"] = generate_token(user_citizen)

          delete :destroy, params: { id: product.id }

          should respond_with(204)
          expect(Product.exists?(product.id)).to be_falsey
        end
      end

      context "Incorrect param" do
        context "Product not found" do
          it "should return 404 HTTP status" do
            user_citizen = create(:citizen_user, email: "citizen5@ecity.fr")
            product = create(:product)
            user_citizen.citizen.products << product
            user_citizen.citizen.save
            request.headers["x-client-id"] = generate_token(user_citizen)
            Product.destroy_all

            delete :destroy, params: { id: product.id }

            should respond_with(404)
          end
        end
      end

      context "Bad authentication" do
        context "x-client-is is missing" do
          it "should return 401 HTTP Status" do
            product = create(:product)

            delete :destroy, params: { id: product.id }

            should respond_with(401)
          end
        end

        context "User is not a citizen" do
          it "should return 403 HTTP status" do
            product = create(:product)
            user_customer = create(:customer_user, email: "customer54@ecity.fr")

            request.headers["x-client-id"] = generate_token(user_customer)

            delete :destroy, params: { id: product.id }

            should respond_with(403)
          end
        end

        context "User is a citizen but not the creator of the product" do
          it "should return 403 HTTP status" do
            product = create(:product)
            user_citizen = create(:citizen_user, email: "citizen543@ecity.fr")

            request.headers["x-client-id"] = generate_token(user_citizen)

            delete :destroy, params: { id: product.id }

            should respond_with(403)
          end
        end
      end
    end

    context "For a shop's product" do
      context "All ok" do
        it "should return 204 HTTP status" do
          product = create(:product)
          user_shop_employee = create(:shop_employee_user, email: "shop.employee687@ecity.fr")
          user_shop_employee.shop_employee.shops << product.shop
          user_shop_employee.shop_employee.save

          request.headers["x-client-id"] = generate_token(user_shop_employee)

          delete :destroy, params: { id: product.id }

          should respond_with(204)
          expect(Product.exists?(product.id)).to be_falsey
        end
      end

      context "Incorrect param" do
        context "Product not found" do
          it "should return 404 HTTP status" do
            product = create(:product)
            user_shop_employee = create(:shop_employee_user, email: "shop.employee688@ecity.fr")

            Product.destroy_all

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            delete :destroy, params: { id: product.id }

            should respond_with(404)
          end
        end
      end

      context "Bad authentication" do
        context "x-client-is is missing" do
          it "should return 401 HTTP Status" do
            product = create(:product)

            delete :destroy, params: { id: product.id }

            should respond_with(401)
          end
        end

        context "User is not a shop employee" do
          it "should return 403 HTTP Status" do
            product = create(:product)
            user_customer = create(:customer_user, email: "customer567@ecity.fr")

            request.headers["x-client-id"] = generate_token(user_customer)

            delete :destroy, params: { id: product.id }

            should respond_with(403)
          end
        end

        context "User is a shop employee but not the owner of the product" do
          it "should return 403 HTTP status" do
            product = create(:product)
            user_shop_employee = create(:shop_employee_user, email: "shop.employee89@ecity.fr")

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            delete :destroy, params: { id: product.id }

            should respond_with(403)
          end
        end
      end
    end
  end

  describe "DELETE #destroy_offline" do
    context "All ok" do
      it "should return 204 HTTP status" do
        product = create(:product)

        delete :destroy_offline, params: { id: product.id }

        should respond_with(204)
        expect(Product.exists?(product.id)).to be_falsey
      end
    end

    context "Incorrect param" do
      context "Product not found" do
        it "should return 404 HTTP status" do
          Product.destroy_all

          delete :destroy_offline, params: { id: 4 }

          should respond_with(404)
        end
      end
    end
  end
end
