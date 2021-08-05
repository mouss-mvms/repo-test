require 'rails_helper'

RSpec.describe Api::Products::JobsController, type: :controller do
    describe "GET #show" do
        context "When it all ok" do
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
                job_id = CreateProductJob.perform_async(serialized_params)
                get :show, params: { id: job_id }
                should respond_with(200)
            end
        end

        context "With inexisting id" do
            it "should return HTTP status 404 - not_found" do
                get :show, params: { id: "10aad2e35138aa982e0d848a" }
                should respond_with(404)
            end
        end
    end
end