require "rails_helper"

RSpec.describe "CreateProductJob", :type => :job do
  it 'should enqueue the job and perform it' do
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
    expect(CreateProductJob.jobs.size).to eq(0)
    CreateProductJob.perform_async(serialized_params)
    expect(CreateProductJob.jobs.size).to eq(1)
    CreateProductJob.drain
    expect(CreateProductJob.jobs.size).to eq(0)
  end
end
