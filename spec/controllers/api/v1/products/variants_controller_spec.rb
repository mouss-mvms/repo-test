require 'rails_helper'

RSpec.describe Api::V1::Products::VariantsController, type: :controller do
  describe 'DELETE #destroy' do
    context 'All ok' do
      it 'should return 204 HTTP status' do
        shop = create(:shop)
        product = create(:product)
        ref1 = create(:reference)
        product.references << ref1
        ref2 = create(:reference)
        product.references << ref2
        product.save
        shop.products << product

        user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
        user_shop_employee.shop_employee.shops << shop
        user_shop_employee.shop_employee.save

        shop.owner = user_shop_employee.shop_employee
        shop.save

        request.headers["x-client-id"] = generate_token(user_shop_employee)

        delete :destroy, params: {product_id: product.id, id: ref1.id}

        expect(response).to have_http_status(:no_content)
        expect(Reference.where(id: ref1.id).any?).to be_falsey
      end
    end

    context 'Bad authentication' do
      context "x-client-id is missing" do
        it "should return 401 HTTP status" do
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save

          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:unauthorized)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context 'User is not a shop employee' do
        it 'should return 403 HTTP status' do
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save

          user_citizen = create(:citizen_user, email: "citizen678987@ecity.fr")
          request.headers["x-client-id"] = generate_token(user_citizen)

          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end


      context "User is shop employee but not the owner of shop which send the product" do
        it 'should return 403 HTTP status' do
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save

          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          request.headers["x-client-id"] = generate_token(user_shop_employee)

          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)

        end
      end
    end

    context 'Bad params' do
      context "Product doesn't find" do
        it 'should return 404 HTTP Status' do
          shop = create(:shop)
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save
          shop.products << product

          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save

          shop.owner = user_shop_employee.shop_employee
          shop.save

          request.headers["x-client-id"] = generate_token(user_shop_employee)
          Product.destroy_all
          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{product.id}").to_h.to_json)
        end
      end

      context "Reference doesn't exist for the product" do
        it 'should return 404 HTTP Status' do
          shop = create(:shop)
          product = create(:product)
          ref1 = create(:reference)
          ref2 = create(:reference)
          product.references << ref2
          product.save
          shop.products << product

          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save

          shop.owner = user_shop_employee.shop_employee
          shop.save

          request.headers["x-client-id"] = generate_token(user_shop_employee)

          delete :destroy, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Reference with 'id'=#{ref1.id} [WHERE \"pr_references\".\"product_id\" = $1]").to_h.to_json)
        end
      end
    end
  end

  describe 'DELETE #destroy_offline' do
    context 'All ok' do
      it 'should return 204 HTTP status' do
        shop = create(:shop)
        product = create(:product)
        ref1 = create(:reference)
        product.references << ref1
        ref2 = create(:reference)
        product.references << ref2
        product.save
        shop.products << product
        shop.save

        delete :destroy_offline, params: {product_id: product.id, id: ref1.id}

        expect(response).to have_http_status(:no_content)
        expect(Reference.where(id: ref1.id).any?).to be_falsey
      end
    end

    context 'Bad Params' do
      context "Product doesn't find" do
        it 'should return 404 HTTP Status' do
          shop = create(:shop)
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save
          shop.products << product

          Product.destroy_all
          delete :destroy_offline, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{product.id}").to_h.to_json)
        end
      end

      context "Reference doesn't exist for the product" do
        it 'should return 404 HTTP Status' do
          shop = create(:shop)
          product = create(:product)
          ref1 = create(:reference)
          ref2 = create(:reference)
          product.references << ref2
          product.save
          shop.products << product

          delete :destroy_offline, params: {product_id: product.id, id: ref1.id}

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Reference with 'id'=#{ref1.id} [WHERE \"pr_references\".\"product_id\" = $1]").to_h.to_json)
        end
      end
    end
  end

  describe "POST #create_offline (no_auth)" do
    context "All ok" do
      it "should return created variant" do
        api_provider = create(:api_provider, name: 'wynd')
        product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
        variant_params = {
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
              name: "color",
              value: "coloris black",
            },
            {
              name: "size",
              value: "S",
            },
          ],
          provider: {
            name: api_provider.name,
            externalVariantId: "34ty"
          }
        }

        Reference.destroy_all
        expect(Reference.count).to eq(0)

        post :create_offline, params: variant_params.merge(id: product.id)
        should respond_with(201)
        expect(Reference.count).to eq(1)
        expect(response.body).to eq(Dto::V1::Variant::Response.create(Reference.first).to_h.to_json)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        expect(product.references.pluck(:id)).to include(response_body[:id])
        expect(response_body[:basePrice]).to eq(variant_params[:basePrice])
        expect(response_body[:weight]).to eq(variant_params[:weight])
        expect(response_body[:quantity]).to eq(variant_params[:quantity])
        expect(response_body[:imageUrls].count).to eq(variant_params[:imageUrls].count)
        expect(response_body[:goodDeal]).to eq(variant_params[:goodDeal])
        expect(response_body[:characteristics].map(&:values)).to eq(variant_params[:characteristics].map(&:values))
        expect(response_body[:provider]).to eq(variant_params[:provider])
      end
    end

    context "Bad params" do

      context "product does not exist" do
        it "should return 404 HTTP status" do
          variant_params = {
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
              name: 'wynd',
              externalVariantId: "34ty"
            }
          }
          post :create_offline, params: variant_params.merge(id: 69)
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Product with 'id'=69").to_h.to_json)
        end
      end

      context "variant" do
        context "required params are missing" do
          it "should return 400 HTTP status" do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            required_params = %i[basePrice weight quantity isDefault]
            variant_params = {
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
                name: api_provider.name,
                externalVariantId: "34ty"
              }
            }

            required_params.each do |required_param|
              params = variant_params.dup
              params.delete(required_param)

              post :create_offline, params: params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end

        context "required params are nil" do
          it "should return 400 HTTP status" do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            required_params = %i[basePrice weight quantity isDefault]
            variant_params = {
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
                name: api_provider.name,
                externalVariantId: "34ty"
              }
            }

            required_params.each do |required_param|
              params = variant_params.dup
              params[required_param] = nil

              post :create_offline, params: params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end
      end

      context 'provider' do
        context 'provider is missing' do
          it 'should return 400 HTTP Status' do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            variant_params = {
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
            }

            Reference.destroy_all
            expect(Reference.count).to eq(0)

            post :create_offline, params: variant_params.merge(id: product.id)
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: provider").to_h.to_json)
          end
        end

        context 'Name of provider is missing' do
          it 'should return 400 HTTP Status' do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            variant_params = {
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
                externalVariantId: '99ki'
              }
            }

            Reference.destroy_all
            expect(Reference.count).to eq(0)

            post :create_offline, params: variant_params.merge(id: product.id)
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: name").to_h.to_json)
          end
        end

        context 'External Variant id of provider is missing' do
          it 'should return 400 HTTP Status' do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            variant_params = {
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
                name: 'wynd'
              }
            }

            Reference.destroy_all
            expect(Reference.count).to eq(0)

            post :create_offline, params: variant_params.merge(id: product.id)
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: externalVariantId").to_h.to_json)
          end
        end

        context 'The provider setted is not the same as the product' do
          it 'should return 403 HTTP Status' do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            variant_params = {
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
                name: 'other',
                externalVariantId: "34ty"
              }
            }

            Reference.destroy_all
            expect(Reference.count).to eq(0)

            post :create_offline, params: variant_params.merge(id: product.id)
            should respond_with(403)
            expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          end
        end

        context 'The product has not api provider' do
          it 'should return 403 HTTP Status' do
            product = create(:available_product)
            variant_params = {
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
                name: 'other',
                externalVariantId: "34ty"
              }
            }

            Reference.destroy_all
            expect(Reference.count).to eq(0)

            post :create_offline, params: variant_params.merge(id: product.id)
            should respond_with(403)
            expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          end
        end
      end

      context "good_deal" do
        context "required params are missing" do
          it "should return 400 HTTP status" do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider)
                             )
            required_params = %i[startAt endAt discount]
            required_params.each do |required_param|
              variant_params = {
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
                  name: 'wynd',
                  externalVariantId: "34ty"
                }
              }

              variant_params[:goodDeal].delete(required_param)
              post :create_offline, params: variant_params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end

        context "required params are nil" do
          it "should return 400 HTTP status" do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            required_params = %i[startAt endAt discount]

            required_params.each do |required_param|
              variant_params = {
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
                  name: api_provider.name,
                  externalVariantId: "34ty"
                }
              }
              variant_params[:goodDeal][required_param] = nil

              post :create_offline, params: variant_params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end
      end

      context "characteristics" do
        context "required params are missing" do
          it "should return 400 HTTP status" do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            required_params = %i[value name]

            required_params.each do |required_param|
              variant_params = {
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
                  }
                ],
                provider: {
                  name:  api_provider.name,
                  externalVariantId: "34ty"
                }
              }
              variant_params[:characteristics].first.delete(required_param)

              post :create_offline, params: variant_params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end

        context "required params are nil" do
          it "should return 400 HTTP status" do
            api_provider = create(:api_provider, name: 'wynd')
            product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
            required_params = %i[value name]

            required_params.each do |required_param|
              variant_params = {
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
                  }
                ],
                provider: {
                  name: api_provider.name,
                  externalVariantId: "34ty"
                }
              }
              variant_params[:characteristics].first[required_param] = nil

              post :create_offline, params: variant_params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end
      end
    end
  end

  describe "POST #create (auth)" do
    context "All ok" do
      it "should return created a variant" do
        shop = create(:shop)
        product = create(:available_product)
        shop.products << product
        user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
        user_shop_employee.shop_employee.shops << shop
        user_shop_employee.shop_employee.save

        shop.owner = user_shop_employee.shop_employee
        shop.save

        request.headers["x-client-id"] = generate_token(user_shop_employee)

        variant_params = {
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
              name: "color",
              value: "coloris black",
            },
            {
              name: "size",
              value: "S",
            },
          ],

        }

        post :create, params: variant_params.merge(id: product.id)
        should respond_with(201)
        expect(response.body).to eq(Dto::V1::Variant::Response.create(Reference.last).to_h.to_json)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        expect(product.references.pluck(:id)).to include(response_body[:id])
        expect(response_body[:basePrice]).to eq(variant_params[:basePrice])
        expect(response_body[:weight]).to eq(variant_params[:weight])
        expect(response_body[:quantity]).to eq(variant_params[:quantity])
        expect(response_body[:imageUrls].count).to eq(variant_params[:imageUrls].count)
        expect(response_body[:goodDeal]).to eq(variant_params[:goodDeal])
        expect(response_body[:characteristics].map(&:values)).to eq(variant_params[:characteristics].map(&:values))
        expect(response_body[:externalVariantId]).to eq(variant_params[:externalVariantId])
      end
    end

    context 'Bad authentication' do
      context "x-client-id is missing" do
        it "should return 401 HTTP status" do
          shop = create(:shop)
          product = create(:available_product)
          shop.products << product
          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save

          shop.owner = user_shop_employee.shop_employee
          shop.save

          variant_params = {
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

          }
          post :create, params: variant_params.merge(id: product.id)
          should respond_with(401)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context 'User is not a shop employee' do
        it 'should return 403 HTTP status' do
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save

          user_citizen = create(:citizen_user, email: "citizen678987@ecity.fr")
          request.headers["x-client-id"] = generate_token(user_citizen)

          variant_params = {
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

          }

          post :create, params: variant_params.merge(id: product.id)

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end


      context "User is shop employee but not the owner of shop which send the product" do
        it 'should return 403 HTTP status' do
          product = create(:product)
          ref1 = create(:reference)
          product.references << ref1
          ref2 = create(:reference)
          product.references << ref2
          product.save

          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          request.headers["x-client-id"] = generate_token(user_shop_employee)

          variant_params = {
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

          }

          post :create, params: variant_params.merge(id: product.id)

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)

        end
      end
    end

    context "Bad Params" do
      context "product id is missing" do
        it "should return 400 HTTP status" do
          shop = create(:shop)
          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save

          shop.owner = user_shop_employee.shop_employee
          shop.save

          request.headers["x-client-id"] = generate_token(user_shop_employee)

          variant_params = {
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

          }
          post :create, params: variant_params.merge(id: "")
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: id").to_h.to_json)
        end
      end

      context "product does not exist" do
        it "should return 404 HTTP status" do
          shop = create(:shop)
          user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
          user_shop_employee.shop_employee.shops << shop
          user_shop_employee.shop_employee.save

          shop.owner = user_shop_employee.shop_employee
          shop.save

          request.headers["x-client-id"] = generate_token(user_shop_employee)

          variant_params = {
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

          }
          post :create, params: variant_params.merge(id: 69)
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Product with 'id'=69").to_h.to_json)
        end
      end

      context "variant" do
        context "required params are missing" do
          it "should return 400 HTTP status" do
            shop = create(:shop)
            product = create(:available_product)
            shop.products << product
            user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
            user_shop_employee.shop_employee.shops << shop
            user_shop_employee.shop_employee.save

            shop.owner = user_shop_employee.shop_employee
            shop.save

            request.headers["x-client-id"] = generate_token(user_shop_employee)


            required_params = %i[basePrice weight quantity isDefault]
            variant_params = {
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

            }

            required_params.each do |required_param|
              params = variant_params.dup
              params.delete(required_param)

              post :create, params: params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end

        context "required params are nil" do
          it "should return 400 HTTP status" do
            shop = create(:shop)
            product = create(:available_product)
            shop.products << product
            user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
            user_shop_employee.shop_employee.shops << shop
            user_shop_employee.shop_employee.save

            shop.owner = user_shop_employee.shop_employee
            shop.save

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            required_params = %i[basePrice weight quantity isDefault]
            variant_params = {
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

            }

            required_params.each do |required_param|
              params = variant_params.dup
              params[required_param] = nil

              post :create, params: params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end
      end

      context "good_deal" do
        context "required params are missing" do
          it "should return 400 HTTP status" do
            shop = create(:shop)
            product = create(:available_product)
            shop.products << product
            user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
            user_shop_employee.shop_employee.shops << shop
            user_shop_employee.shop_employee.save

            shop.owner = user_shop_employee.shop_employee
            shop.save

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            required_params = %i[startAt endAt discount]

            required_params.each do |required_param|
              variant_params = {
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

              }
              variant_params[:goodDeal].delete(required_param)

              post :create, params: variant_params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end

        context "required params are nil" do
          it "should return 400 HTTP status" do
            shop = create(:shop)
            product = create(:available_product)
            shop.products << product
            user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
            user_shop_employee.shop_employee.shops << shop
            user_shop_employee.shop_employee.save

            shop.owner = user_shop_employee.shop_employee
            shop.save

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            required_params = %i[startAt endAt discount]

            required_params.each do |required_param|
              variant_params = {
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

              }
              variant_params[:goodDeal][required_param] = nil

              post :create, params: variant_params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end
      end

      context "characteristics" do
        context "required params are missing" do
          it "should return 400 HTTP status" do
            shop = create(:shop)
            product = create(:available_product)
            shop.products << product
            user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
            user_shop_employee.shop_employee.shops << shop
            user_shop_employee.shop_employee.save

            shop.owner = user_shop_employee.shop_employee
            shop.save

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            required_params = %i[value name]

            required_params.each do |required_param|
              variant_params = {
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
                  }
                ],

              }
              variant_params[:characteristics].first.delete(required_param)

              post :create, params: variant_params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end

        context "required params are nil" do
          it "should return 400 HTTP status" do
            shop = create(:shop)
            product = create(:available_product)
            shop.products << product
            user_shop_employee = create(:shop_employee_user, email: "shop.employee310@ecity.fr")
            user_shop_employee.shop_employee.shops << shop
            user_shop_employee.shop_employee.save

            shop.owner = user_shop_employee.shop_employee
            shop.save

            request.headers["x-client-id"] = generate_token(user_shop_employee)

            required_params = %i[value name]

            required_params.each do |required_param|
              variant_params = {
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
                  }
                ],

              }
              variant_params[:characteristics].first[required_param] = nil

              post :create, params: variant_params.merge(id: product.id)
              should respond_with(400)
              expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: #{required_param}").to_h.to_json)
            end
          end
        end
      end
    end
  end
end