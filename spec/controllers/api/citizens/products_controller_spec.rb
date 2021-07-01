require 'rails_helper'

RSpec.describe Api::Citizens::ProductsController, type: :controller do
  describe 'GET #show' do
    context 'All ok' do
      let(:citizen) {create(:citizen)}
      let(:product) {create(:product)}

      it 'should return 200 HTTP Status with product response' do
        citizen.products << product
        citizen.save
        get :show, params: {id: citizen.id, product_id: product.id}

        should respond_with(200)
        product_result = JSON.parse(response.body)
        expect(product_result['product']['id']).to eq(product.id)
        expect(product_result['product']['name']).to eq(product.name)
        expect(product_result['product']['brand']).to eq(product.brand)
        expect(product_result['product']['status']).to eq(product.status)
        expect(product_result['product']['sellerAdvice']).to eq(product.pro_advice)
        expect(product_result['product']['description']).to eq(product.description)
        expect(product_result['product']['citizenAdvice']).to eq(product.advice&.content)
      end
    end

    context 'Citizen not found' do
      let(:product) {create(:product)}

      it 'should return 404 HTTP Status' do
        Citizen.destroy_all
        get :show, params: {id: 34, product_id: product.id}

        should respond_with(404)
      end
    end

    context 'Product not found' do
      let(:citizen) {create(:citizen)}

      it 'should return 404 HTTP Status' do
        Product.destroy_all
        get :show, params: {id: citizen.id, product_id: 88}

        should respond_with(404)
      end
    end

    context "Product exists but it's not a citizen's product" do
      let(:citizen) {create(:citizen)}
      let(:product) {create(:product)}

      it 'should return 404 HTTP Status' do
        get :show, params: {id: citizen.id, product_id: product.id}

        should respond_with(404)
      end
    end
  end

  describe 'PUT #update' do

    context 'All Ok' do
      let(:citizen_user) { create(:citizen_user) }
      let(:product) {create(:product)}

      it 'should return 200 HTTP Status with product updated' do
        citizen_user.citizen.products << product
        citizen_user.citizen.save
        @update_params = {
          name: "Nom MAJ",
          categoryId: product.category_id,
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
              isDefault: false,
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
          ],
          citizenAdvice: "pouet pouet"
        }

        request.headers['HTTP_X_CLIENT_ID'] = generate_token(citizen_user)

        put :update, params: @update_params.merge({id: citizen_user.citizen_id, product_id: product.id})

        should respond_with(200)
        product_result = JSON.parse(response.body)
        expect(product_result['product']['id']).to eq(product.id)
        expect(product_result['product']['name']).to eq(@update_params[:name])
        expect(product_result['product']['brand']).to eq(@update_params[:brand])
        expect(product_result['product']['status']).to eq(@update_params[:status])
        expect(product_result['product']['sellerAdvice']).to eq(@update_params[:sellerAdvice])
        expect(product_result['product']['description']).to eq(@update_params[:description])
        expect(product_result['product']['citizenAdvice']).to eq(@update_params[:citizenAdvice])
      end
    end

    context "with invalid url" do
      let(:citizen_user) {create(:citizen_user)}
      let(:product) {create(:product)}
      before(:each) do
        @category = create(:category_for_product)
        @update_params = {
          name: "Nom MAJ",
          categoryId: @category.id,
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
              isDefault: false,
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
          ],
          citizenAdvice: "pouet pouet"
        }
      end

      context "product_id not a Numeric" do
        it "should returns 400 HTTP Status" do
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(citizen_user)
          put :update, params: @update_params.merge(product_id: 'ChuckNorris', id: citizen_user.citizen_id)
          should respond_with(400)
        end
      end

      context "id not a Numeric" do
        it "should returns 400 HTTP Status" do
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(citizen_user)
          put :update, params: @update_params.merge(id: 'Terminator', product_id: product.id)
          should respond_with(400)
        end
      end
    end

    context "with invalid params" do
      let(:citizen) {create(:citizen)}
      let(:product) {create(:product)}

      context 'x-client-id is missing' do
        let(:citizen_user) { create(:citizen_user) }
        it 'should return 401 HTTP status' do
          put :update, params: { id: citizen_user.citizen.id, product_id: product.id }
          should respond_with(401)
        end
      end

      context 'User is not the citizen' do
        let(:citizen_user) { create(:citizen_user) }
        it 'should return 401 HTTP status' do
          put :update, params: { id: citizen_user.citizen.id, product_id: product.id }
          should respond_with(401)
        end
      end

      context "No params" do
        let(:citizen_user) { create(:citizen_user) }
        let(:product) { create(:product) }
        it "should returns 400 HTTP status" do
          citizen_user.citizen.products << product
          citizen_user.citizen.save
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(citizen_user)
          put :update, params: { id: citizen_user.citizen_id, product_id: product.id }
          should respond_with(400)
        end
      end

      context "Category doesn't exists" do
        let(:citizen_user) { create(:citizen_user) }
        it "should returns 404 HTTP status" do
          Category.destroy_all
          @update_params = {
            name: "Nom MAJ",
            categoryId: 2,
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
                isDefault: false,
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
            ],
            citizenAdvice: "pouet pouet"
          }

          request.headers['HTTP_X_CLIENT_ID'] = generate_token(citizen_user)
          put :update, params: @update_params.merge({id: citizen_user.citizen_id, product_id: product.id})
          should respond_with(404)
        end
      end

      context "Product doesn't exists" do
        let(:citizen_user) { create(:citizen_user) }
        it "should returns 404 HTTP status" do
          @category = create(:category_for_product)
          @update_params = {
            name: "Nom MAJ",
            categoryId: @category.id,
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
                isDefault: false,
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
            ],
            citizenAdvice: "pouet pouet"
          }

          request.headers['HTTP_X_CLIENT_ID'] = generate_token(citizen_user)
          put :update, params: @update_params.merge({id: citizen_user.citizen_id, product_id: product.id})
          should respond_with(404)
        end
      end

      context 'Citizen not found' do
        let(:product) {create(:product)}
        let(:user) {create(:user)}
        it 'should return 404 HTTP Status' do
          Citizen.destroy_all
          request.headers['HTTP_X_CLIENT_ID'] = generate_token(user)

          put :update, params: {id: 34, product_id: product.id}

          should respond_with(404)
        end
      end
    end
  end
end

def generate_token(user)
  exp_payload = { id: user.id, exp: Time.now.to_i + 1 * 3600 * 24 }
  JWT.encode exp_payload, ENV["JWT_SECRET"], 'HS256'
end
