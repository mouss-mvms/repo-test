require 'rails_helper'

RSpec.describe Dto::V1::ProductSummary::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::ProductSummary::Response' do
        product = {
          "_index"=>"products_v1_20210315162727103",
          "_type"=>"_doc",
          "_id"=>"21034",
          "_score"=>0.9976985,
          "id"=>21034,
          "name"=>"MIRACLE : L'ENVOÛTANT PARFUM D'UN PÂTÉ BRASSÉ",
          "slug"=>"miracle-l-envoutant-parfum-d-un-pate-brasse",
          "created_at"=>"2020-04-10T14:44:53.723+02:00",
          "updated_at"=>"2020-04-10T14:46:26.902+02:00",
          "description"=> "Par cette collaboration, l’idée est de se fondre dans l’agrosystème mis en place entre l’éleveur du Prince Noir de Biscay et la brasserie Mira. Par ce mécanisme soigneusement orchestré, le bon sens commun et la culture raisonnée sont mis à l’honneur. C’est un retour aux fondamentaux, au sens de la vie, au « Miracle » de la vie.\r\n\r\nAccompagné de sa phrase « L’envoûtant parfum d’un pâté brassé », on retrouve l’évocation du charme envoûtant de cette bière brune et son parfum si délicat.\r\n\r\nIngrédients: Viande, gorge et foie de porc Prince noir de Biscay, Bière Brune de la Brasserie Mira, sel, poivre, ail et une pincée d’amour.",
          "base_price"=>5.5,
          "good_deal_starts_at"=>"2020-04-10T00:00:00.000+02:00",
          "good_deal_ends_at"=>"2020-04-30T23:59:59.999+02:00",
          "price"=>5.5,
          "quantity"=>100,
          "category_id"=>2204,
          "category_tree_names"=>["Alimentation", "Conserves et plats cuisinés", "Epicerie salée"],
          "category_tree_ids"=>[2054, 2204, 2194],
          "status"=>"online",
          "shop_name"=>"LES CONSERVISTES",
          "shop_id"=>2088,
          "shop_slug"=>"les-conservistes",
          "in_holidays"=>false,
          "brand_name"=>"LES CONSERVISTES",
          "brand_id"=>4494,
          "city_name"=>"Bordeaux",
          "city_label"=>"Bordeaux",
          "city_slug"=>"bordeaux",
          "conurbation_slug"=>"bordeaux",
          "insee_code"=>"33063",
          "territory_name"=>"Bordeaux Métropole",
          "territory_slug"=>"bordeaux-metropole",
          "department_number"=>"33",
          "product_citizen_nickname"=>nil,
          "product_citizen_slug"=>nil,
          "product_citizen_image_path"=>nil,
          "default_sample_id"=>25301,
          "shop_pictogram_url"=> "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/48072/file/thumb-417b0aeed958591c590cb5d0e619f38f.jpg",
          "image_url"=> "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/46718/file/thumb-473860700deac939fb02d2a0263cf171.jpg",
          "product_page_url"=> "https://mavillemonshopping-dev.herokuapp.com/fr/bordeaux/les-conservistes/alimentation/epicerie-salee/conserves-et-plats-cuisines/produits/miracle-l-envoutant-parfum-d-un-pate-brasse",
          "shop_url"=>"/fr/bordeaux/boutiques/les-conservistes",
          "number_of_orders"=>0,
          "colors"=>["Modèle par défaut"],
          "sizes"=>["130 G", "190 G"],
          "selection_ids"=>[],
          "services"=> ["e-reservation", "livraison-par-colissimo", "livraison-express-par-stuart", "click-collect", "livraison-par-le-commercant", "livraison-par-la-poste"],
          "shop_is_template"=>false,
          "score"=>0,
          "position"=>nil,
          "indexed_at"=>"2021-07-30T10:29:24.113+02:00",
          "unique_reference_id"=>nil,
          "is_a_service"=>nil}
        result = Dto::V1::ProductSummary::Response.create(**product.symbolize_keys)

        expect(result).to be_instance_of(Dto::V1::ProductSummary::Response)
        expect(result._index).to eq(product["_index"])
        expect(result._type).to eq(product["_type"])
        expect(result._id).to eq(product["_id"])
        expect(result._score).to eq(product["_score"])
        expect(result.id).to eq(product["id"])
        expect(result.name).to eq(product["name"])
        expect(result.slug).to eq(product["slug"])
        expect(result.created_at).to eq(product["created_at"])
        expect(result.updated_at).to eq(product["updated_at"])
        expect(result.description).to eq(product["description"])
        expect(result.base_price).to eq(product["base_price"])
        expect(result.good_deal_starts_at).to eq(product["good_deal_starts_at"])
        expect(result.good_deal_ends_at).to eq(product["good_deal_ends_at"])
        expect(result.price).to eq(product["price"])
        expect(result.quantity).to eq(product["quantity"])
        expect(result.category_id).to eq(product["category_id"])
        expect(result.category_tree_names).to eq(product["category_tree_names"])
        expect(result.category_tree_ids).to eq(product["category_tree_ids"])
        expect(result.status).to eq(product["status"])
        expect(result.shop_name).to eq(product["shop_name"])
        expect(result.shop_id).to eq(product["shop_id"])
        expect(result.shop_slug).to eq(product["shop_slug"])
        expect(result.in_holidays).to eq(product["in_holidays"])
        expect(result.brand_name).to eq(product["brand_name"])
        expect(result.brand_id).to eq(product["brand_id"])
        expect(result.city_name).to eq(product["city_name"])
        expect(result.city_label).to eq(product["city_label"])
        expect(result.city_slug).to eq(product["city_slug"])
        expect(result.conurbation_slug).to eq(product["conurbation_slug"])
        expect(result.insee_code).to eq(product["insee_code"])
        expect(result.territory_name).to eq(product["territory_name"])
        expect(result.territory_slug).to eq(product["territory_slug"])
        expect(result.department_number).to eq(product["department_number"])
        expect(result.product_citizen_nickname).to eq(product["product_citizen_nickname"])
        expect(result.product_citizen_slug).to eq(product["product_citizen_slug"])
        expect(result.product_citizen_slug).to eq(product["product_citizen_slug"])
        expect(result.product_citizen_image_path).to eq(product["product_citizen_image_path"])
        expect(result.default_sample_id).to eq(product["default_sample_id"])
        expect(result.shop_pictogram_url).to eq(product["shop_pictogram_url"])
        expect(result.image_url).to eq(product["image_url"])
        expect(result.product_page_url).to eq(product["product_page_url"])
        expect(result.shop_url).to eq(product["shop_url"])
        expect(result.number_of_orders).to eq(product["number_of_orders"])
        expect(result.colors).to eq(product["colors"])
        expect(result.sizes).to eq(product["sizes"])
        expect(result.selection_ids).to eq(product["selection_ids"])
        expect(result.services).to eq(product["services"])
        expect(result.shop_is_template).to eq(product["shop_is_template"])
        expect(result.score).to eq(product["score"])
        expect(result.position).to eq(product["position"])
        expect(result.indexed_at).to eq(product["indexed_at"])
        expect(result.unique_reference_id).to eq(product["unique_reference_id"])
        expect(result.is_a_service).to eq(product["is_a_service"])
        expect(result.on_discount).to eq(false)
        expect(result.discount_price).to eq(product["base_price"])
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
    end
  end
end