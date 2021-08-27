# frozen_string_literal: true

require "rails_helper"

RSpec.describe Dto::V1::ShopSummary::Response do
  describe "create" do
    context "All ok" do
      it "should return a Dto::V1::ShopSummary::Response" do
        shop_search_result = {
          "_index" => "shops_v1_20210315094629392",
          "_type" => "_doc",
          "_id" => "4648",
          "_score" => 0.9988128,
          "name" => "Edessa kebab",
          "created_at" => "2020-05-10T09:07:03.576+02:00",
          "updated_at" => "2020-05-10T09:07:09.498+02:00",
          "slug" => "edessa-kebab",
          "shop_url" => "/fr/sable-sur-sarthe/boutiques/edessa-kebab",
          "category_tree_ids" => [2359, 2371],
          "category_tree_names" => ["Restauration",
                                    "Traiteur"],
          "baseline" => "pouet",
          "description" => "pouet",
          "brands_name" => [""],
          "city_label" => "Sablé-sur-Sarthe",
          "city_slug" => "sable-sur-sarthe",
          "insee_code" => "72264",
          "territory_name" => "pouet",
          "territory_slug" => "pouet",
          "department_number" => "72",
          "deleted_at" => "pouet",
          "number_of_online_products" => 3,
          "number_of_orders" => 0,
          "image_url" => "default_box_shop.svg",
          "coupons" => "[]",
          "pictogram_url" => "pouet",
          "services" => ["click-collect",
                         "livraison-express-par-stuart",
                         "livraison-par-la-poste",
                         "livraison-par-colissimo",
                         "e-reservation"],
          "is_template" => false,
          "score" => 0,
          "indexed_at" => "2021-06-28T18:36:54.691+00:00",
          "id" => "4648",
        }

        dto_response = Dto::V1::ShopSummary::Response.create(**shop_search_result.deep_symbolize_keys)
        expect(dto_response).to be_an_instance_of(Dto::V1::ShopSummary::Response)
        expect(dto_response._index).to eq(shop_search_result["_index"])
        expect(dto_response._type).to eq(shop_search_result["_type"])
        expect(dto_response._id).to eq(shop_search_result["_id"])
        expect(dto_response._score).to eq(shop_search_result["_score"])
        expect(dto_response.id).to eq(shop_search_result["id"])
        expect(dto_response.name).to eq(shop_search_result["name"])
        expect(dto_response.created_at).to eq(shop_search_result["created_at"])
        expect(dto_response.updated_at).to eq(shop_search_result["updated_at"])
        expect(dto_response.slug).to eq(shop_search_result["slug"])
        expect(dto_response.shop_url).to eq(shop_search_result["shop_url"])
        expect(dto_response.in_holidays).to eq(shop_search_result["in_holidays"])
        expect(dto_response.category_tree_ids).to eq(shop_search_result["category_tree_ids"])
        expect(dto_response.category_tree_names).to eq(shop_search_result["category_tree_names"])
        expect(dto_response.baseline).to eq(shop_search_result["baseline"])
        expect(dto_response.description).to eq(shop_search_result["description"])
        expect(dto_response.brands_name).to eq(shop_search_result["brands_name"])
        expect(dto_response.city_label).to eq(shop_search_result["city_label"])
        expect(dto_response.city_slug).to eq(shop_search_result["city_slug"])
        expect(dto_response.insee_code).to eq(shop_search_result["insee_code"])
        expect(dto_response.territory_name).to eq(shop_search_result["territory_name"])
        expect(dto_response.territory_slug).to eq(shop_search_result["territory_slug"])
        expect(dto_response.department_number).to eq(shop_search_result["department_number"])
        expect(dto_response.deleted_at).to eq(shop_search_result["deleted_at"])
        expect(dto_response.number_of_online_products).to eq(shop_search_result["number_of_online_products"])
        expect(dto_response.number_of_orders).to eq(shop_search_result["number_of_orders"])
        expect(dto_response.image_url).to eq(shop_search_result["image_url"])
        expect(dto_response.coupons).to eq(shop_search_result["coupons"])
        expect(dto_response.pictogram_url).to eq(shop_search_result["pictogram_url"])
        expect(dto_response.services).to eq(shop_search_result["services"])
        expect(dto_response.is_template).to eq(shop_search_result["is_template"])
        expect(dto_response.score).to eq(shop_search_result["score"])
        expect(dto_response.indexed_at).to eq(shop_search_result["indexed_at"])
      end
    end
  end

  describe "to_h" do
    context "All ok" do
      it "should return a hash representation Dto::V1::ShopSummary::Response" do
        shop_search_result = {
          "_index" => "shops_v1_20210315094629392",
          "_type" => "_doc",
          "_id" => "4648",
          "_score" => 0.9988128,
          "name" => "Edessa kebab",
          "created_at" => "2020-05-10T09:07:03.576+02:00",
          "updated_at" => "2020-05-10T09:07:09.498+02:00",
          "slug" => "edessa-kebab",
          "shop_url" => "/fr/sable-sur-sarthe/boutiques/edessa-kebab",
          "category_tree_ids" => [2359, 2371],
          "category_tree_names" => ["Restauration",
                                    "Traiteur"],
          "baseline" => "pouet",
          "description" => "pouet",
          "brands_name" => [""],
          "city_label" => "Sablé-sur-Sarthe",
          "city_slug" => "sable-sur-sarthe",
          "insee_code" => "72264",
          "territory_name" => "pouet",
          "territory_slug" => "pouet",
          "department_number" => "72",
          "deleted_at" => "pouet",
          "number_of_online_products" => 3,
          "number_of_orders" => 0,
          "image_url" => "default_box_shop.svg",
          "coupons" => "[]",
          "pictogram_url" => "pouet",
          "services" => ["click-collect",
                         "livraison-express-par-stuart",
                         "livraison-par-la-poste",
                         "livraison-par-colissimo",
                         "e-reservation"],
          "is_template" => false,
          "score" => 0,
          "indexed_at" => "2021-06-28T18:36:54.691+00:00",
          "id" => "4648",
        }

        dto_response = Dto::V1::ShopSummary::Response.create(**shop_search_result.deep_symbolize_keys)
        dto_hash = dto_response.to_h

        expect(dto_hash).to be_an_instance_of(Hash)
        expect(dto_hash[:_index]).to eq(dto_response._index)
        expect(dto_hash[:_type]).to eq(dto_response._type)
        expect(dto_hash[:_id]).to eq(dto_response._id)
        expect(dto_hash[:_score]).to eq(dto_response._score)
        expect(dto_hash[:id]).to eq(dto_response.id)
        expect(dto_hash[:name]).to eq(dto_response.name)
        expect(dto_hash[:createdAt]).to eq(dto_response.created_at)
        expect(dto_hash[:updatedAt]).to eq(dto_response.updated_at)
        expect(dto_hash[:slug]).to eq(dto_response.slug)
        expect(dto_hash[:shopUrl]).to eq(dto_response.shop_url)
        expect(dto_hash[:inHolidays]).to eq(dto_response.in_holidays)
        expect(dto_hash[:categoryTreeIds]).to eq(dto_response.category_tree_ids)
        expect(dto_hash[:categoryTreeNames]).to eq(dto_response.category_tree_names)
        expect(dto_hash[:baseline]).to eq(dto_response.baseline)
        expect(dto_hash[:description]).to eq(dto_response.description)
        expect(dto_hash[:brandsName]).to eq(dto_response.brands_name)
        expect(dto_hash[:cityLabel]).to eq(dto_response.city_label)
        expect(dto_hash[:citySlug]).to eq(dto_response.city_slug)
        expect(dto_hash[:inseeCode]).to eq(dto_response.insee_code)
        expect(dto_hash[:territoryName]).to eq(dto_response.territory_name)
        expect(dto_hash[:territorySlug]).to eq(dto_response.territory_slug)
        expect(dto_hash[:departmentNumber]).to eq(dto_response.department_number)
        expect(dto_hash[:deletedAt]).to eq(dto_response.deleted_at)
        expect(dto_hash[:numberOfOnlineProducts]).to eq(dto_response.number_of_online_products)
        expect(dto_hash[:numberOfOrders]).to eq(dto_response.number_of_orders)
        expect(dto_hash[:imageUrl]).to eq(dto_response.image_url)
        expect(dto_hash[:coupons]).to eq(dto_response.coupons)
        expect(dto_hash[:pictogramUrl]).to eq(dto_response.pictogram_url)
        expect(dto_hash[:services]).to eq(dto_response.services)
        expect(dto_hash[:isTemplate]).to eq(dto_response.is_template)
        expect(dto_hash[:score]).to eq(dto_response.score)
        expect(dto_hash[:indexedAt]).to eq(dto_response.indexed_at)
      end
    end
  end
end
