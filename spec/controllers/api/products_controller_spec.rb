require 'rails_helper'

RSpec.describe Api::ProductsController, type: :controller do
  describe "PUT #update_offline" do
    context 'All ok' do
      it 'should return 200 HTTP status with product updated' do
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
                discount: 20
              },
              characteristics: [
                {
                  value: "coloris black",
                  name: "color"
                },
                {
                  value: "S",
                  name: "size"
                }
              ]
            }
          ]
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
      end
    end

    context 'Incorrect Params' do
      context 'Product not found' do
        it 'should return 404 HTTP Status' do
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
                  discount: 20
                },
                characteristics: [
                  {
                    value: "coloris black",
                    name: "color"
                  },
                  {
                    value: "S",
                    name: "size"
                  }
                ]
              }
            ]
          }
          Product.destroy_all

          put :update_offline, params: update_params.merge(id: 3)

          should respond_with(404)
        end
      end

      context 'Category id is missing' do
        it 'should return 400 HTTP status' do
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
                  discount: 20
                },
                characteristics: [
                  {
                    value: "coloris black",
                    name: "color"
                  },
                  {
                    value: "S",
                    name: "size"
                  }
                ]
              }
            ]
          }

          put :update_offline, params: update_params.merge(id: product.id)

          should respond_with(400)
        end
      end

      context 'Category not found' do
        it 'should return 404 HTTP status' do
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
                  discount: 20
                },
                characteristics: [
                  {
                    value: "coloris black",
                    name: "color"
                  },
                  {
                    value: "S",
                    name: "size"
                  }
                ]
              }
            ]
          }
          Product.all.each do |p|
            p.category_id = nil
            p.save
          end
          Category.delete_all

          put :update_offline, params: update_params.merge(id: product.id)

          should respond_with(400)
        end
      end
    end
  end

  describe "PUT #update" do
    context "For a citizen's product" do
      context 'All ok' do
        it 'should return 200 HTTP Status with product updated' do
          user_citizen = create(:citizen_user)
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
                  discount: 20
                },
                characteristics: [
                  {
                    value: "coloris black",
                    name: "color"
                  },
                  {
                    value: "S",
                    name: "size"
                  }
                ]
              }
            ]
          }

          request.headers['x-client-id'] = generate_token(user_citizen)

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
        end
      end

      context 'Incorrect Params' do
        context 'Product not found' do
          it 'should return 404 HTTP Status' do
            user_citizen = create(:citizen_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }
            Product.destroy_all

            request.headers['x-client-id'] = generate_token(user_citizen)

            put :update, params: update_params.merge(id: 3)

            should respond_with(404)
          end
        end

        context 'Category id is missing' do
          it 'should return 400 HTTP status' do
            user_citizen = create(:citizen_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }
            request.headers['x-client-id'] = generate_token(user_citizen)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(400)
          end
        end

        context 'Category not found' do
          it 'should return 404 HTTP status' do
            user_citizen = create(:citizen_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }
            request.headers['x-client-id'] = generate_token(user_citizen)
            Product.all.each do |p|
              p.category_id = nil
              p.save
            end
            Category.delete_all

            put :update, params: update_params.merge(id: product.id)

            should respond_with(400)
          end
        end
      end

      context 'Bad authentication' do
        context 'x-client-id is missing' do
          it 'should return 401 HTTP Status' do
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }

            put :update, params: update_params.merge(id: product.id)

            should respond_with(401)
          end
        end

        context 'User not found' do
          it 'should return 403 HTTP Status' do
            user_citizen = create(:citizen_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }

            request.headers['x-client-id'] = generate_token(user_citizen)
            User.delete_all

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end

        context 'User is not a citizen' do
          it 'should return 403 HTTP Status' do
            user_citizen = create(:citizen_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }

            user_shop_employee = create(:shop_employee_user)
            request.headers['x-client-id'] = generate_token(user_shop_employee)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end

        context 'User is a citizen but not the owner of the product' do
          it 'should return 403 HTTP Status' do
            user_citizen = create(:citizen_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }

            request.headers['x-client-id'] = generate_token(user_citizen)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end
      end
    end

    context "For a shop's product" do
      context 'All ok' do
        it 'should return 200 HTTP Status with product updated' do
          user_shop_employee = create(:shop_employee_user)
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
                  discount: 20
                },
                characteristics: [
                  {
                    value: "coloris black",
                    name: "color"
                  },
                  {
                    value: "S",
                    name: "size"
                  }
                ]
              }
            ]
          }

          request.headers['x-client-id'] = generate_token(user_shop_employee)

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
        end
      end

      context 'Bad authentication' do
        context 'x-client-id is missing' do
          it 'should return 401 HTTP Status' do
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }

            put :update, params: update_params.merge(id: product.id)

            should respond_with(401)
          end
        end

        context 'User not found' do
          it 'should return 403 HTTP Status' do
            user_citizen = create(:citizen_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }

            request.headers['x-client-id'] = generate_token(user_citizen)
            User.delete_all

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end

        context 'User is not a shop employee' do
          it 'should return 403 HTTP Status' do
            user_shop_employee = create(:shop_employee_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }

            user_citizen = create(:citizen_user)
            request.headers['x-client-id'] = generate_token(user_citizen)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end

        context 'User is a shop employee but the shop is not the owner of the product' do
          it 'should return 403 HTTP Status' do
            user_shop_employee = create(:shop_employee_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }

            request.headers['x-client-id'] = generate_token(user_shop_employee)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(403)
          end
        end
      end

      context 'Incorrect Params' do
        context 'Product not found' do
          it 'should return 404 HTTP Status' do
            user_shop_employee = create(:shop_employee_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }
            Product.destroy_all

            request.headers['x-client-id'] = generate_token(user_shop_employee)

            put :update, params: update_params.merge(id: 3)

            should respond_with(404)
          end
        end

        context 'Category id is missing' do
          it 'should return 400 HTTP status' do
            user_shop_employee = create(:shop_employee_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }
            request.headers['x-client-id'] = generate_token(user_shop_employee)

            put :update, params: update_params.merge(id: product.id)

            should respond_with(400)
          end
        end

        context 'Category not found' do
          it 'should return 404 HTTP status' do
            user_shop_employee = create(:shop_employee_user)
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
                    discount: 20
                  },
                  characteristics: [
                    {
                      value: "coloris black",
                      name: "color"
                    },
                    {
                      value: "S",
                      name: "size"
                    }
                  ]
                }
              ]
            }
            request.headers['x-client-id'] = generate_token(user_shop_employee)
            Product.all.each do |p|
              p.category_id = nil
              p.save
            end
            Category.delete_all

            put :update, params: update_params.merge(id: product.id)

            should respond_with(404)
          end
        end
      end

    end
  end
end

def generate_token(user)
  exp_payload = { id: user.id, exp: Time.now.to_i + 1 * 3600 * 24 }
  JWT.encode exp_payload, ENV["JWT_SECRET"], 'HS256'
end
