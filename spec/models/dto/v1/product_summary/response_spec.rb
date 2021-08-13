require 'rails_helper'

RSpec.describe Dto::V1::ProductSummary::Response do

  describe 'create' do
    context 'All ok' do
      context 'without discount' do
        it 'should return a Dto::V1::ProductSummary::Response' do
          product_search_result = {
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
          result = Dto::V1::ProductSummary::Response.create(**product_search_result.symbolize_keys)

          expect(result).to be_instance_of(Dto::V1::ProductSummary::Response)
          expect(result._index).to eq(product_search_result["_index"])
          expect(result._type).to eq(product_search_result["_type"])
          expect(result._id).to eq(product_search_result["_id"])
          expect(result._score).to eq(product_search_result["_score"])
          expect(result.id).to eq(product_search_result["id"])
          expect(result.name).to eq(product_search_result["name"])
          expect(result.slug).to eq(product_search_result["slug"])
          expect(result.created_at).to eq(product_search_result["created_at"])
          expect(result.updated_at).to eq(product_search_result["updated_at"])
          expect(result.description).to eq(product_search_result["description"])
          expect(result.base_price).to eq(product_search_result["base_price"])
          expect(result.good_deal_starts_at).to eq(product_search_result["good_deal_starts_at"])
          expect(result.good_deal_ends_at).to eq(product_search_result["good_deal_ends_at"])
          expect(result.price).to eq(product_search_result["price"])
          expect(result.quantity).to eq(product_search_result["quantity"])
          expect(result.category_id).to eq(product_search_result["category_id"])
          expect(result.category_tree_names).to eq(product_search_result["category_tree_names"])
          expect(result.category_tree_ids).to eq(product_search_result["category_tree_ids"])
          expect(result.status).to eq(product_search_result["status"])
          expect(result.shop_name).to eq(product_search_result["shop_name"])
          expect(result.shop_id).to eq(product_search_result["shop_id"])
          expect(result.shop_slug).to eq(product_search_result["shop_slug"])
          expect(result.in_holidays).to eq(product_search_result["in_holidays"])
          expect(result.brand_name).to eq(product_search_result["brand_name"])
          expect(result.brand_id).to eq(product_search_result["brand_id"])
          expect(result.city_name).to eq(product_search_result["city_name"])
          expect(result.city_label).to eq(product_search_result["city_label"])
          expect(result.city_slug).to eq(product_search_result["city_slug"])
          expect(result.conurbation_slug).to eq(product_search_result["conurbation_slug"])
          expect(result.insee_code).to eq(product_search_result["insee_code"])
          expect(result.territory_name).to eq(product_search_result["territory_name"])
          expect(result.territory_slug).to eq(product_search_result["territory_slug"])
          expect(result.department_number).to eq(product_search_result["department_number"])
          expect(result.product_citizen_nickname).to eq(product_search_result["product_citizen_nickname"])
          expect(result.product_citizen_slug).to eq(product_search_result["product_citizen_slug"])
          expect(result.product_citizen_slug).to eq(product_search_result["product_citizen_slug"])
          expect(result.product_citizen_image_path).to eq(product_search_result["product_citizen_image_path"])
          expect(result.default_sample_id).to eq(product_search_result["default_sample_id"])
          expect(result.shop_pictogram_url).to eq(product_search_result["shop_pictogram_url"])
          expect(result.image_url).to eq(product_search_result["image_url"])
          expect(result.product_page_url).to eq(product_search_result["product_page_url"])
          expect(result.shop_url).to eq(product_search_result["shop_url"])
          expect(result.number_of_orders).to eq(product_search_result["number_of_orders"])
          expect(result.colors).to eq(product_search_result["colors"])
          expect(result.sizes).to eq(product_search_result["sizes"])
          expect(result.selection_ids).to eq(product_search_result["selection_ids"])
          expect(result.services).to eq(product_search_result["services"])
          expect(result.shop_is_template).to eq(product_search_result["shop_is_template"])
          expect(result.score).to eq(product_search_result["score"])
          expect(result.position).to eq(product_search_result["position"])
          expect(result.indexed_at).to eq(product_search_result["indexed_at"])
          expect(result.unique_reference_id).to eq(product_search_result["unique_reference_id"])
          expect(result.is_a_service).to eq(product_search_result["is_a_service"])
          expect(result.on_discount).to eq(false)
          expect(result.discount_price).to eq(product_search_result["base_price"])
        end
      end

      context 'with discount' do
        it 'should return a Dto::V1::ProductSummary::Response' do
          product_search_result = {
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
            "good_deal_starts_at"=>(DateTime.now - 2.days).to_s,
            "good_deal_ends_at"=>(DateTime.now + 2.days).to_s,
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

          product = create(:available_product, id: product_search_result["id"])
          result = Dto::V1::ProductSummary::Response.create(**product_search_result.symbolize_keys)

          expect(result).to be_instance_of(Dto::V1::ProductSummary::Response)
          expect(result._index).to eq(product_search_result["_index"])
          expect(result._type).to eq(product_search_result["_type"])
          expect(result._id).to eq(product_search_result["_id"])
          expect(result._score).to eq(product_search_result["_score"])
          expect(result.id).to eq(product_search_result["id"])
          expect(result.name).to eq(product_search_result["name"])
          expect(result.slug).to eq(product_search_result["slug"])
          expect(result.created_at).to eq(product_search_result["created_at"])
          expect(result.updated_at).to eq(product_search_result["updated_at"])
          expect(result.description).to eq(product_search_result["description"])
          expect(result.base_price).to eq(product_search_result["base_price"])
          expect(result.good_deal_starts_at).to eq(product_search_result["good_deal_starts_at"])
          expect(result.good_deal_ends_at).to eq(product_search_result["good_deal_ends_at"])
          expect(result.price).to eq(product_search_result["price"])
          expect(result.quantity).to eq(product_search_result["quantity"])
          expect(result.category_id).to eq(product_search_result["category_id"])
          expect(result.category_tree_names).to eq(product_search_result["category_tree_names"])
          expect(result.category_tree_ids).to eq(product_search_result["category_tree_ids"])
          expect(result.status).to eq(product_search_result["status"])
          expect(result.shop_name).to eq(product_search_result["shop_name"])
          expect(result.shop_id).to eq(product_search_result["shop_id"])
          expect(result.shop_slug).to eq(product_search_result["shop_slug"])
          expect(result.in_holidays).to eq(product_search_result["in_holidays"])
          expect(result.brand_name).to eq(product_search_result["brand_name"])
          expect(result.brand_id).to eq(product_search_result["brand_id"])
          expect(result.city_name).to eq(product_search_result["city_name"])
          expect(result.city_label).to eq(product_search_result["city_label"])
          expect(result.city_slug).to eq(product_search_result["city_slug"])
          expect(result.conurbation_slug).to eq(product_search_result["conurbation_slug"])
          expect(result.insee_code).to eq(product_search_result["insee_code"])
          expect(result.territory_name).to eq(product_search_result["territory_name"])
          expect(result.territory_slug).to eq(product_search_result["territory_slug"])
          expect(result.department_number).to eq(product_search_result["department_number"])
          expect(result.product_citizen_nickname).to eq(product_search_result["product_citizen_nickname"])
          expect(result.product_citizen_slug).to eq(product_search_result["product_citizen_slug"])
          expect(result.product_citizen_slug).to eq(product_search_result["product_citizen_slug"])
          expect(result.product_citizen_image_path).to eq(product_search_result["product_citizen_image_path"])
          expect(result.default_sample_id).to eq(product_search_result["default_sample_id"])
          expect(result.shop_pictogram_url).to eq(product_search_result["shop_pictogram_url"])
          expect(result.image_url).to eq(product_search_result["image_url"])
          expect(result.product_page_url).to eq(product_search_result["product_page_url"])
          expect(result.shop_url).to eq(product_search_result["shop_url"])
          expect(result.number_of_orders).to eq(product_search_result["number_of_orders"])
          expect(result.colors).to eq(product_search_result["colors"])
          expect(result.sizes).to eq(product_search_result["sizes"])
          expect(result.selection_ids).to eq(product_search_result["selection_ids"])
          expect(result.services).to eq(product_search_result["services"])
          expect(result.shop_is_template).to eq(product_search_result["shop_is_template"])
          expect(result.score).to eq(product_search_result["score"])
          expect(result.position).to eq(product_search_result["position"])
          expect(result.indexed_at).to eq(product_search_result["indexed_at"])
          expect(result.unique_reference_id).to eq(product_search_result["unique_reference_id"])
          expect(result.is_a_service).to eq(product_search_result["is_a_service"])
          expect(result.on_discount).to eq(true)
          expect(result.discount_price).to eq(product.cheapest_ref.price)
        end
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::ProductSummary::Response' do
        product_search_result = {
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

        dto = Dto::V1::ProductSummary::Response.create(**product_search_result.symbolize_keys)
        dto_hash = dto.to_h

        expect(dto_hash[:_index]).to eq(dto._index)
        expect(dto_hash[:_type]).to eq(dto._type)
        expect(dto_hash[:_id]).to eq(dto._id)
        expect(dto_hash[:_score]).to eq(dto._score)
        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:name]).to eq(dto.name)
        expect(dto_hash[:slug]).to eq(dto.slug)
        expect(dto_hash[:createdAt]).to eq(dto.created_at)
        expect(dto_hash[:updatedAt]).to eq(dto.updated_at)
        expect(dto_hash[:description]).to eq(dto.description)
        expect(dto_hash[:basePrice]).to eq(dto.base_price)
        expect(dto_hash[:goodDealStartsAt]).to eq(dto.good_deal_starts_at)
        expect(dto_hash[:goodDealEndsAt]).to eq(dto.good_deal_ends_at)
        expect(dto_hash[:price]).to eq(dto.price)
        expect(dto_hash[:quantity]).to eq(dto.quantity)
        expect(dto_hash[:categoryId]).to eq(dto.category_id)
        expect(dto_hash[:categoryTreeNames]).to eq(dto.category_tree_names)
        expect(dto_hash[:categoryTreeIds]).to eq(dto.category_tree_ids)
        expect(dto_hash[:status]).to eq(dto.status)
        expect(dto_hash[:shopName]).to eq(dto.shop_name)
        expect(dto_hash[:shopId]).to eq(dto.shop_id)
        expect(dto_hash[:shopSlug]).to eq(dto.shop_slug)
        expect(dto_hash[:inHolidays]).to eq(dto.in_holidays)
        expect(dto_hash[:brandName]).to eq(dto.brand_name)
        expect(dto_hash[:brandId]).to eq(dto.brand_id)
        expect(dto_hash[:cityName]).to eq(dto.city_name)
        expect(dto_hash[:cityLabel]).to eq(dto.city_label)
        expect(dto_hash[:citySlug]).to eq(dto.city_slug)
        expect(dto_hash[:conurbationSlug]).to eq(dto.conurbation_slug)
        expect(dto_hash[:inseeCode]).to eq(dto.insee_code)
        expect(dto_hash[:territoryName]).to eq(dto.territory_name)
        expect(dto_hash[:territorySlug]).to eq(dto.territory_slug)
        expect(dto_hash[:departmentNumber]).to eq(dto.department_number)
        expect(dto_hash[:productCitizenNickname]).to eq(dto.product_citizen_nickname)
        expect(dto_hash[:productCitizenSlug]).to eq(dto.product_citizen_slug)
        expect(dto_hash[:productCitizenSlug]).to eq(dto.product_citizen_slug)
        expect(dto_hash[:productCitizenImagePath]).to eq(dto.product_citizen_image_path)
        expect(dto_hash[:defaultSampleId]).to eq(dto.default_sample_id)
        expect(dto_hash[:shopPictogramUrl]).to eq(dto.shop_pictogram_url)
        expect(dto_hash[:imageUrl]).to eq(dto.image_url)
        expect(dto_hash[:productPageUrl]).to eq(dto.product_page_url)
        expect(dto_hash[:shopUrl]).to eq(dto.shop_url)
        expect(dto_hash[:numberOfOrders]).to eq(dto.number_of_orders)
        expect(dto_hash[:colors]).to eq(dto.colors)
        expect(dto_hash[:sizes]).to eq(dto.sizes)
        expect(dto_hash[:selectionIds]).to eq(dto.selection_ids)
        expect(dto_hash[:services]).to eq(dto.services)
        expect(dto_hash[:shopIsTemplate]).to eq(dto.shop_is_template)
        expect(dto_hash[:score]).to eq(dto.score)
        expect(dto_hash[:position]).to eq(dto.position)
        expect(dto_hash[:indexedAt]).to eq(dto.indexed_at)
        expect(dto_hash[:uniqueReferenceId]).to eq(dto.unique_reference_id)
        expect(dto_hash[:isAService]).to eq(dto.is_a_service)
        expect(dto_hash[:onDiscount]).to eq(dto.on_discount)
        expect(dto_hash[:discountPrice]).to eq(dto.discount_price)
      end
    end
  end
end