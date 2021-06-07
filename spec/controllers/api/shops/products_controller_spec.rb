require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe Api::Shops::ProductsController, type: :controller do

  # GET #index
  describe "GET #index" do
    before(:each) do
      @products = [create(:product), create(:product), create(:product)]
      @shop = create(:shop)
      @products.each { |prod| prod.update(shop_id: @shop.id) }
    end

    context "with valid params" do
      it "get all products from shop" do
        get :index, params: { locale: I18n.locale, shop_id: @shop.id }
        should respond_with(200)

        response_body = JSON.parse(response.body)
        expect(response_body).to be_an_instance_of(Array)
        expect(response_body.count).to eq(3)

        product_ids = response_body.map { |p| p.symbolize_keys[:id] }
        expect(Product.where(id: product_ids).actives.to_a).to eq(@products)
      end
    end

    context "with invalid params" do
      it "Returns 400 Bad Request if shop_id not a Numeric" do
        get :index, params: { locale: I18n.locale, shop_id: 'Xenomorph' }
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Shop_id is incorrect", "message"=>"Bad Request", "status"=>400})
      end

      it "Returns 404 Not Found if shop doesn't exists" do
        get :index, params: { locale: I18n.locale, shop_id: (@shop.id + 1) }
        should respond_with(404)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Couldn't find Shop with 'id'=#{@shop.id + 1}", "message"=>"Not Found", "status"=>404})
      end
    end
  end

  # GET #show
  describe "GET #show" do
    before(:each) do
      @product = create(:product)
      @shop = create(:shop)
      @product.update(shop_id: @shop.id)
    end

    context "with valid params" do
      it "get all products from shop" do
        get :show, params: { locale: I18n.locale, shop_id: @shop.id, id: @product.id }
        should respond_with(200)

        expect(response.body).to eq(Dto::Product::Response.create(@product).to_h.to_json)
      end
    end

    context "with invalid params" do
      it "Returns 400 Bad Request if shop_id not a Numeric" do
        get :show, params: { locale: I18n.locale, shop_id: 'Kowabunga', id: @product.id }
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Shop_id is incorrect", "message"=>"Bad Request", "status"=>400})
      end

      it "Returns 400 Bad Request if id not a Numeric" do
        get :show, params: { locale: I18n.locale, shop_id: @shop.id, id: '§§' }
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Id is incorrect", "message"=>"Bad Request", "status"=>400})
      end

      it "Returns 404 Not Found if shop doesn't exists" do
        get :show, params: { locale: I18n.locale, shop_id: (@shop.id + 1), id: @product.id }
        should respond_with(404)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Couldn't find Shop with 'id'=#{@shop.id + 1}", "message"=>"Not Found", "status"=>404})
      end

      it "Returns 404 Not Found if product doesn't exists" do
        post :show, params: { locale: I18n.locale, shop_id: @product.shop_id, id: (@product.id + 1) }
        should respond_with(404)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Couldn't find Product with 'id'=#{@product.id + 1}", "message"=>"Not Found", "status"=>404})
      end
    end
  end

  # POST #create
  describe "POST #create" do
    before(:each) do
      @shop = create(:shop)
      @category = create(:category_for_product)
      @create_params = {
        name: "manteau MAC",
        slug: "manteau-mac",
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
            imageUrls: ['https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg'],
            isDefault: false,
            goodDeal: {
              startAt: "17/05/2021",
              endAt: "18/06/2021",
              discount: 20
            },
            characteristics: [
              {
                name: "coloris black",
                type: "color"
              },
              {
                name: "S",
                type: "size"
              }
            ]
          }
        ]
      }
    end

    context "with valid params" do
      it "creates a product" do
        post :create, params: @create_params.merge(locale: I18n.locale, shop_id: @shop.id)
        should respond_with(201)
        expect(response.body).to eq(Dto::Product::Response.create(Product.first).to_h.to_json)
      end
    end

    context "with invalid params" do
      it "Returns 400 Bad Request if shop_id not a Numeric" do
        post :create, params: @create_params.merge(locale: I18n.locale, shop_id: "ErenJäger")
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Shop_id is incorrect", "message"=>"Bad Request", "status"=>400})
      end

      it "Returns 404 Not Found if category doesn't exists" do
        @create_params[:categoryId] += 1
        post :create, params: @create_params.merge(locale: I18n.locale, shop_id: @shop.id)
        should respond_with(404)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Couldn't find Category with 'id'=#{@create_params[:categoryId]}", "message"=>"Not Found", "status"=>404})
      end

      it "Returns 400 Bad Request if name is not a present" do
        @create_params.delete(:name)
        post :create, params: @create_params.merge(locale: I18n.locale, shop_id: @shop.id)
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Name is incorrect", "message"=>"Bad Request", "status"=>400})
      end

      it "Returns 400 Bad Request if name is blank" do
        @create_params[:name] = ""
        post :create, params: @create_params.merge(locale: I18n.locale, shop_id: @shop.id)
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Name is incorrect", "message"=>"Bad Request", "status"=>400})
      end
    end
  end

  # PUT #update
  describe "PUT #update" do
    before(:each) do
      @product = create(:product_with_category)
      @update_params = {
        name: "Lot de 4 tasses à café style rétro AOC",
        categoryId: @product.category_id,
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
            imageUrls: ['https://www.eklecty-city.fr/wp-content/uploads/2018/07/robocop-paul-verhoeven-banner.jpg'],
            isDefault: true,
            goodDeal: {
              startAt: "17/05/2021",
              endAt: "18/06/2021",
              discount: 20
            },
            characteristics: [
              {
                name: "Taille unique",
                type: "size"
              },
              {
                name: "Rouge",
                type: "color"
              }
            ]
          }
        ]
      }
    end

    context "with valid params" do
      it "Updates a product" do
        put :update, params: @update_params.merge(locale: I18n.locale, shop_id: @product.shop_id, id: @product.id)
        should respond_with(200)
        expect(response.body).to eq(Dto::Product::Response.create(Product.first).to_h.to_json)
      end
    end

    context "with invalid url" do
      it "Returns 400 Bad Request if shop_id not a Numeric" do
        put :update, params: @update_params.merge(locale: I18n.locale, shop_id: 'ChuckNorris', id: @product.id)
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Shop_id is incorrect", "message"=>"Bad Request", "status"=>400})
      end


      it "Returns 400 Bad Request if id not a Numeric" do
        put :update, params: @update_params.merge(locale: I18n.locale, shop_id: @product.shop_id, id: 'Terminator')
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Id is incorrect", "message"=>"Bad Request", "status"=>400})
      end
    end

    context "with invalid params" do
      it "Returns 400 Bad Request if no params" do
        put :update, params: { locale: I18n.locale, shop_id: @product.shop_id, id: @product.id }
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"The syntax of the query is incorrect: Can't update without relevant params", "message"=>"Bad Request", "status"=>400})
      end

      it "Returns 404 Not Found if category doesn't exists" do
        @update_params[:categoryId] = 1
        put :update, params: @update_params.merge(locale: I18n.locale, shop_id: @product.shop_id, id: @product.id)
        should respond_with(404)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Couldn't find Category with 'id'=#{@update_params[:categoryId]}", "message"=>"Not Found", "status"=>404})
      end

      it "Returns 404 Not Found if product doesn't exists" do
        put :update, params: @update_params.merge(locale: I18n.locale, shop_id: @product.shop_id, id: (@product.id + 1))
        should respond_with(404)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Couldn't find Product with 'id'=#{@product.id + 1}", "message"=>"Not Found", "status"=>404})
      end
    end
  end

  # DELETE #destroy
  describe "DELETE #destroy" do
    before(:each) do
      @product = create(:product)
      @shop = create(:shop)
      @product.update(shop_id: @shop.id)
    end

    context "with valid params" do
      it "deletes a product" do
        expect(Product.count).to eq(1)
        delete :destroy, params: { locale: I18n.locale, shop_id: @shop.id, id: @product.id }
        should respond_with(204)

        expect(Product.count).to be_zero
      end
    end

    context "with invalid params" do
      it "Returns 400 Bad Request if shop_id not a Numeric" do
        get :show, params: { locale: I18n.locale, shop_id: 'Kowabunga', id: @product.id }
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Shop_id is incorrect", "message"=>"Bad Request", "status"=>400})
      end

      it "Returns 400 Bad Request if id not a Numeric" do
        get :show, params: { locale: I18n.locale, shop_id: @shop.id, id: '§§' }
        should respond_with(400)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Id is incorrect", "message"=>"Bad Request", "status"=>400})
      end

      it "Returns 404 Not Found if shop doesn't exists" do
        get :show, params: { locale: I18n.locale, shop_id: (@shop.id + 1), id: @product.id }
        should respond_with(404)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Couldn't find Shop with 'id'=#{@shop.id + 1}", "message"=>"Not Found", "status"=>404})
      end

      it "Returns 404 Not Found if product doesn't exists" do
        post :show, params: { locale: I18n.locale, shop_id: @product.shop_id, id: (@product.id + 1) }
        should respond_with(404)
        expect(JSON.parse(response.body)).to eq({"detail"=>"Couldn't find Product with 'id'=#{@product.id + 1}", "message"=>"Not Found", "status"=>404})
      end
    end
  end
end



