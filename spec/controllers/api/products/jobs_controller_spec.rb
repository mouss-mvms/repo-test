require 'rails_helper'

RSpec.describe Api::Products::JobsController, type: :controller do
    describe "GET #show" do
        context "When it all ok" do
            let(:id) {"10aad2e35138aa982e0d848b" }
            it "should return HTTP status 200 - ok" do
                shop = create(:shop)
                category = create(:category)
                create_params = {
                name: "TEST Job create with sidekiq de ses morts",
                shop_id: shop.id,
                description: "Chaise longue pour jardin extérieur.",
                category_id: category.id,
                brand: "Lafuma",
                status: "online",
                seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
                is_service: false,
                origin: "france",
                composition: "pouet pouet",
                allergens: "Eric Zemmour",
                variants: [
                    {
                    base_price: 20.5,
                    weight: 20.5,
                    quantity: 20,
                    is_default: false,
                    good_deal: {
                        start_at: "20/01/2021",
                        end_at: "16/02/2021",
                        discount: "20"
                    },
                    characteristics: [
                        {
                        name: "color",
                        value: "blue"
                        },
                        {
                            name: "size",
                            value: "S"
                        }
                    ]
                    }
                ]
                    }
                serialized_params = JSON.dump(Dto::Product::Request.new(create_params).to_h)
                allow(Sidekiq::Status).to receive(:status).and_return("completed")
                allow(Sidekiq::Status).to receive(:get).and_return("12")
                get :show, params: { id: id }
                should respond_with(200)
            end
        end

        context "With inexisting id" do
            let(:id) {"10bbd2e35138bb982e0d848a" }
            it "should return HTTP status 404 - not_found" do
                allow(Sidekiq::Status).to receive(:status).and_return(nil)
                allow(Sidekiq::Status).to receive(:get).and_return(nil)
                get :show, params: { id: id }
                should respond_with(404)
            end
        end
    end
end