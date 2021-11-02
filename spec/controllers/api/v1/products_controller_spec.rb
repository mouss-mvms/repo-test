require "rails_helper"

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "PUT #update_offline" do
    context "All ok" do
      it "should return 200 HTTP status with product updated" do
        product = create(:product)
        provider = create(:api_provider, name: 'wynd')
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
              externalVariantId: 'trd54'
            },
            {
              basePrice: 30,
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
              externalVariantId: 'rzsd98'
            },
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
        update_params[:variants].each do |variant_param|
          to_compare = result["variants"].find{ |r_variant|
            r_variant["externalVariantId"] == variant_param[:externalVariantId]
          }
          expect(to_compare).to_not be_nil
          expect(to_compare["basePrice"]).to eq(variant_param[:basePrice])
          expect(to_compare["quantity"]).to eq(variant_param[:quantity])
          expect(to_compare["weight"]).to eq(variant_param[:weight])
        end
      end
    end

    context "Incorrect Params" do
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

          put :update_offline, params: update_params.merge(id: 3)

          should respond_with(404)
        end
      end

      context "Category id is missing" do
        it "should return 400 HTTP status" do
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

          put :update_offline, params: update_params.merge(id: product.id)

          should respond_with(404)
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
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
                },
              ],
            }

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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

            put :update_offline, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
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
              expect(result["detail"]).to eq("origin and composition is required")
            end
          end
        end
      end
    end
  end

  describe "PATCH #patch_auth" do
    context "All ok" do
      context "when the user is the shop owner" do
        it 'should return 200 HTTP status code with the updated product' do
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
          patch :patch_auth, params: product_params.merge(id: product.id)
          should respond_with(200)
        end
      end
    end

    context 'Authentication incorrect' do
      context "No user" do
        it "should return 401" do
          patch :update, params: { id: 33 }
          expect(response).to have_http_status(401)
        end
      end

      context "User is admin" do
        before(:each) do
          @admin_user = create(:admin_user)
        end
        it "should return 403" do
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(@admin_user)
          reference = create(:reference)
          patch :update, params: {id: reference.id}
          expect(response).to have_http_status(403)
        end
      end

      context "User is not the owner of shop" do
        it "Should return 403 HTTP Status" do
          shop_employee_user = create(:shop_employee_user, email: 'shop.employee536@ecity.fr')
          reference = create(:reference)
          product = reference.product
          shop = reference.shop
          product_params = {
            name: "manteau MAC",
            slug: "manteau-mac",
            categoryId: create(:category).id,
            brand: "3sixteen",
            status: "online",
            isService: true,
            sellerAdvice: "pouet",
            shopId: shop.id,
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
          request.headers["HTTP_X_CLIENT_ID"] = generate_token(shop_employee_user)
          patch :update, params: product_params.merge(id: product.id)

          expect(response).to have_http_status(403)
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
          patch :patch_auth, params: product_params.merge(id: product.id)
          should respond_with(400)
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
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is clothing group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "clothing") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
    end
  end

  describe "PATCH #patch" do
    context "All ok" do
      context "when request comme from over provider" do
        it 'should return 200 HTTP status code with the updated product' do
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
          patch :patch, params: product_params.merge(id: product.id)
          should respond_with(200)
        end
      end
    end

    context "Incorrect Params" do

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
          patch :patch_auth, params: product_params.merge(id: product.id)
          should respond_with(400)
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
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("allergens is required")
          end
        end
      end

      context "Category is clothing group" do
        let(:product) { create(:product) }
        let(:category) { create(:category, group: "clothing") }

        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
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
                },
              ],
            }

            patch :patch, params: update_params.merge(id: product.id)

            should respond_with(400)
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
            result = JSON.parse(response.body)
            expect(result["detail"]).to eq("origin and composition is required")
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
      it "should return 202 HTTP Status" do
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
              externalVariantId: "tyh46"
            },
          ],
          provider: {
            name: 'wynd',
            externalProductId: '56ty'
          }
        }
        job_id = "10aad2e35138aa982e0d848a"
        allow(Dao::Product).to receive(:create_async).and_return(job_id)
        expect(Dao::Product).to receive(:create_async)
        post :create_offline, params: create_params
        should respond_with(202)
        expect(JSON.parse(response.body)["url"]).to eq(ENV["API_BASE_URL"] + api_v1_product_job_status_path(job_id))
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
                externalVariantId: "tyh46"
              },
            ],
            provider: {
              name: 'wynd',
              externalProductId: '56ty'
            }
          }
          Shop.destroy_all

          post :create_offline, params: create_params

          should respond_with(404)
        end
      end

      context "Category id is missing" do
        it "should return 400 HTTP status" do
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
              },
            ],
          }

          post :create_offline, params: create_params

          should respond_with(400)
        end
      end

      context "Category not found" do
        it "should return 404 HTTP Status" do
          create_params = {
            name: "manteau MAC",
            slug: "manteau-mac",
            brand: "3sixteen",
            status: "online",
            categoryId: create(:category).id,
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
                externalVariantId: "tyh46"
              },
            ],
            provider: {
              name: 'wynd',
              externalProductId: '56ty'
            }
          }
          Product.all.each do |p|
            p.category_id = nil
            p.save
          end
          Category.delete_all

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

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Composition of product is missing" do
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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Allergens of product is missing" do
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
                  externalVariantId: "tyh46"

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

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "fresh-food"
            category.save

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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "fresh-food"
            category.save

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
                  externalVariantId: "tyh46"

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

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "frozen-food"
            category.save

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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "frozen-food"
            category.save

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
                  externalVariantId: "tyh46"

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

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "alcohol"
            category.save

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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "alcohol"
            category.save

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
                  externalVariantId: "tyh46"

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

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "cosmetic"
            category.save

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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "cosmetic"
            category.save

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
                  externalVariantId: "tyh46"

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

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "food"
            category.save

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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Allergens of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "food"
            category.save

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
                  externalVariantId: "tyh46"

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
        context "Origin of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "clothing"
            category.save

            create_params = {
              name: "manteau MAC",
              slug: "manteau-mac",
              categoryId: category.id,
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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
          end
        end

        context "Composition of product is missing" do
          it "should return 400 HTTP Status" do
            category = create(:category)
            category.group = "clothing"
            category.save

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
                  externalVariantId: "tyh46"

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
            expect(result["detail"]).to eq("origin and composition is required")
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
        context 'If provider is wynd and externalProductId is missing' do
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
        context 'External variant id is missing in one variant' do
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
                name: 'wynd',
                externalProductId: '56ty'
              }
            }

            post :create_offline, params: create_params

            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: variant.externalVariantId').to_h.to_json)
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

def generate_token(user)
  exp_payload = { id: user.id, exp: Time.now.to_i + 1 * 3600 * 24 }
  JWT.encode exp_payload, ENV["JWT_SECRET"], "HS256"
end
