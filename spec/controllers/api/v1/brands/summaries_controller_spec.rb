require 'rails_helper'

RSpec.describe Api::V1::Brands::SummariesController do
  describe 'POST #search' do
    context "All ok" do
      context "when no params" do
        it 'returns a Dto::V1::Brand::Search::Response' do
          searchkick_brands = Searchkick::Results.new(Brand, no_params_response, no_params_options)

          allow(::Requests::BrandSearches).to receive(:search).and_return(searchkick_brands)
          brands = searchkick_brands.map { |brand| brand }
          post :search
          should respond_with(200)
          expect(response.body).to eq(Dto::V1::Brand::Search::Response.create(brands: brands, page: searchkick_brands.options[:page]).to_h.to_json)
          expect(JSON.load(response.body)['page']).to eq(no_params_options[:page])
        end
      end

      context "when params :q" do
        it "should return a Dto::V1::Brand::Search::Response with only matches" do
          search_params = { q: "nike" }
          searchkick_brands = Searchkick::Results.new(Brand, params_q_response, params_q_options)

          allow(::Requests::BrandSearches).to receive(:search).and_return(searchkick_brands)
          brands = searchkick_brands.map { |brand| brand }
          post :search, params: search_params
          should respond_with(200)
          dto_search = Dto::V1::Brand::Search::Response.create(brands: brands, page: searchkick_brands.options[:page])
          expect(response.body).to eq(dto_search.to_h.to_json)
          expect(dto_search.brands.count).to eq(12)
          expect(dto_search.page).to eq(1)
        end
      end

      context "when params :page and :sort_by" do
        it "should return a Dto::V1::Brand::Search::Response with productsCounts: DESC and page:" do
          search_params = { sortBy: "products-count", page: 2 }
          searchkick_brands = Searchkick::Results.new(Brand, sort_by_and_page_response, sort_by_and_page_options)

          allow(::Requests::BrandSearches).to receive(:search).and_return(searchkick_brands)
          brands = searchkick_brands.map { |brand| brand }
          post :search, params: search_params
          should respond_with(200)
          dto_search = Dto::V1::Brand::Search::Response.create(brands: brands, page: searchkick_brands.options[:page])
          expect(dto_search.brands.count).to eq(15)
          expect(response.body).to eq(dto_search.to_h.to_json)
          expect(JSON.parse(response.body)["brands"].map {|brand| brand["productsCount"] }).to eq(searchkick_brands.map {|b| b["products_count"]}.sort.reverse)
          expect(dto_search.page).to eq(search_params[:page])
        end
      end
    end
  end

  def no_params_options
    {
      per_page: 15,
      page: 1,
      padding: 0,
      load: false,
      includes: nil,
      model_includes: nil,
      json: false,
      match_suffix: "analyzed",
      highlight: nil,
      highlighted_fields: [],
      misspellings: false,
      term: "*",
      scope_results: nil,
      total_entries: nil,
      index_mapping: nil,
      suggest: nil,
      scroll: nil
    }
  end

  def no_params_response
    {
      "took" => 3, "timed_out" => false, "_shards" => {
        "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0
      }, "hits" => {
        "total" => {
          "value" => 10000, "relation" => "gte"
        }, "max_score" => 1.0, "hits" => [{
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21273",
          "_score" => 1.0,
          "_source" => {
            "id" => 21273, "name" => "ZOOBREW", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:09.653+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21274",
          "_score" => 1.0,
          "_source" => {
            "id" => 21274, "name" => "Classic Disney", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:09.655+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21275",
          "_score" => 1.0,
          "_source" => {
            "id" => 21275, "name" => "VAPTIO", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:09.657+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21276",
          "_score" => 1.0,
          "_source" => {
            "id" => 21276, "name" => "Maxi bombata ", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:09.659+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21277",
          "_score" => 1.0,
          "_source" => {
            "id" => 21277, "name" => "Corps de Loup", "products_count" => 2, "indexed_at" => "2021-10-08T15:03:09.661+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21278",
          "_score" => 1.0,
          "_source" => {
            "id" => 21278, "name" => "Black Bottle ", "products_count" => 2, "indexed_at" => "2021-10-08T15:03:09.663+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21279",
          "_score" => 1.0,
          "_source" => {
            "id" => 21279, "name" => "PU-DAN-R01", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:09.665+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21280",
          "_score" => 1.0,
          "_source" => {
            "id" => 21280, "name" => "Grim Fantaisy ", "products_count" => 0, "indexed_at" => "2021-10-08T15:03:09.667+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21281",
          "_score" => 1.0,
          "_source" => {
            "id" => 21281, "name" => "La Rade", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:09.669+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21282",
          "_score" => 1.0,
          "_source" => {
            "id" => 21282, "name" => "La Chaîne d’Or depuis 1751", "products_count" => 4, "indexed_at" => "2021-10-08T15:03:09.672+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21283",
          "_score" => 1.0,
          "_source" => {
            "id" => 21283, "name" => "Peackock", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:09.674+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21284",
          "_score" => 1.0,
          "_source" => {
            "id" => 21284, "name" => "ZOUMAI", "products_count" => 2, "indexed_at" => "2021-10-08T15:03:09.676+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21285",
          "_score" => 1.0,
          "_source" => {
            "id" => 21285, "name" => "Pol Roger", "products_count" => 2, "indexed_at" => "2021-10-08T15:03:09.678+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21286",
          "_score" => 1.0,
          "_source" => {
            "id" => 21286, "name" => "La Chaine d’Or depuis 1751", "products_count" => 5, "indexed_at" => "2021-10-08T15:03:09.680+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21287",
          "_score" => 1.0,
          "_source" => {
            "id" => 21287, "name" => "OM-BA-AJOUR", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:09.682+00:00"
          }
        }]
      }
    }
  end

  def params_q_options
    {
      :page=>1,
      :per_page=>15,
      :padding=>0,
      :load=>false,
      :includes=>nil,
      :model_includes=>nil,
      :json=>false,
      :match_suffix=>"analyzed",
      :highlight=>nil,
      :highlighted_fields=>[],
      :misspellings=>false,
      :term=>"nike",
      :scope_results=>nil,
      :total_entries=>nil,
      :index_mapping=>nil,
      :suggest=>nil,
      :scroll=>nil
    }
  end

  def params_q_response
    {
      "took" => 1, "timed_out" => false, "_shards" => {
        "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0
      }, "hits" => {
        "total" => {
          "value" => 12, "relation" => "eq"
        }, "max_score" => 533.5152, "hits" => [{
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "21411",
          "_score" => 533.5152,
          "_source" => {
            "id" => 21411, "name" => "Nike ", "products_count" => 5, "indexed_at" => "2021-10-08T15:03:09.856+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "4748",
          "_score" => 533.5152,
          "_source" => {
            "id" => 4748, "name" => "NIKE ", "products_count" => 3, "indexed_at" => "2021-10-08T15:02:42.130+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "5135",
          "_score" => 533.5152,
          "_source" => {
            "id" => 5135, "name" => "NIKE", "products_count" => 60, "indexed_at" => "2021-10-08T15:02:42.571+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "1",
          "_score" => 533.5152,
          "_source" => {
            "id" => 1, "name" => "Nike", "products_count" => 61, "indexed_at" => "2021-10-08T15:02:34.567+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "8",
          "_score" => 533.5152,
          "_source" => {
            "id" => 8, "name" => "nike", "products_count" => 9, "indexed_at" => "2021-10-08T15:02:34.580+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "26138",
          "_score" => 447.57178,
          "_source" => {
            "id" => 26138, "name" => "Nike👍", "products_count" => 1, "indexed_at" => "2021-10-08T15:03:17.376+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "11996",
          "_score" => 447.57178,
          "_source" => {
            "id" => 11996, "name" => "NIKE SB", "products_count" => 7, "indexed_at" => "2021-10-08T15:02:53.585+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "232",
          "_score" => 447.57178,
          "_source" => {
            "id" => 232, "name" => "Nike SB ", "products_count" => 1, "indexed_at" => "2021-10-08T15:02:34.763+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "616",
          "_score" => 447.57178,
          "_source" => {
            "id" => 616, "name" => "Nike jordan", "products_count" => 2, "indexed_at" => "2021-10-08T15:02:35.216+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "727",
          "_score" => 447.57178,
          "_source" => {
            "id" => 727, "name" => "Nike air", "products_count" => 2, "indexed_at" => "2021-10-08T15:02:35.332+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "694",
          "_score" => 385.47583,
          "_source" => {
            "id" => 694, "name" => "Nike Air Max", "products_count" => 6, "indexed_at" => "2021-10-08T15:02:35.296+00:00"
          }
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "215",
          "_score" => 338.51105,
          "_source" => {
            "id" => 215, "name" => "Nike SB Janoski OG", "products_count" => 0, "indexed_at" => "2021-10-08T15:02:34.745+00:00"
          }
        }]
      }
    }
  end

  def sort_by_and_page_options
    {
      :page=>2,
      :per_page=>15,
      :padding=>0,
      :load=>false,
      :includes=>nil,
      :model_includes=>nil,
      :json=>false,
      :match_suffix=>"analyzed",
      :highlight=>nil,
      :highlighted_fields=>[],
      :misspellings=>false,
      :term=>"*",
      :scope_results=>nil,
      :total_entries=>nil,
      :index_mapping=>nil,
      :suggest=>nil,
      :scroll=>nil
    }
  end

  def sort_by_and_page_response
    {
      "took" => 2, "timed_out" => false, "_shards" => {
        "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0
      }, "hits" => {
        "total" => {
          "value" => 10000, "relation" => "gte"
        }, "max_score" => nil, "hits" => [{
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "2777",
          "_score" => nil,
          "_source" => {
            "id" => 2777, "name" => "Eden Park", "products_count" => 273, "indexed_at" => "2021-10-08T15:02:38.979+00:00"
          },
          "sort" => [273]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "319",
          "_score" => nil,
          "_source" => {
            "id" => 319, "name" => "Moulin Roty", "products_count" => 266, "indexed_at" => "2021-10-08T15:02:34.855+00:00"
          },
          "sort" => [266]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "3042",
          "_score" => nil,
          "_source" => {
            "id" => 3042, "name" => "Guinot", "products_count" => 263, "indexed_at" => "2021-10-08T15:02:39.292+00:00"
          },
          "sort" => [263]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "29385",
          "_score" => nil,
          "_source" => {
            "id" => 29385, "name" => "Résin'Olive", "products_count" => 257, "indexed_at" => "2021-10-08T15:03:23.196+00:00"
          },
          "sort" => [257]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "1804",
          "_score" => nil,
          "_source" => {
            "id" => 1804, "name" => "MEPHISTO", "products_count" => 254, "indexed_at" => "2021-10-08T15:02:37.185+00:00"
          },
          "sort" => [254]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "11136",
          "_score" => nil,
          "_source" => {
            "id" => 11136, "name" => "Newness", "products_count" => 251, "indexed_at" => "2021-10-08T15:02:52.127+00:00"
          },
          "sort" => [251]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "1995",
          "_score" => nil,
          "_source" => {
            "id" => 1995, "name" => "Rieker", "products_count" => 242, "indexed_at" => "2021-10-08T15:02:37.423+00:00"
          },
          "sort" => [242]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "3361",
          "_score" => nil,
          "_source" => {
            "id" => 3361, "name" => "DMC", "products_count" => 241, "indexed_at" => "2021-10-08T15:02:40.071+00:00"
          },
          "sort" => [241]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "4999",
          "_score" => nil,
          "_source" => {
            "id" => 4999, "name" => "Dr renaud", "products_count" => 238, "indexed_at" => "2021-10-08T15:02:42.417+00:00"
          },
          "sort" => [238]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "4490",
          "_score" => nil,
          "_source" => {
            "id" => 4490, "name" => "Thalgo", "products_count" => 237, "indexed_at" => "2021-10-08T15:02:41.822+00:00"
          },
          "sort" => [237]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "64",
          "_score" => nil,
          "_source" => {
            "id" => 64, "name" => "Desigual", "products_count" => 229, "indexed_at" => "2021-10-08T15:02:34.606+00:00"
          },
          "sort" => [229]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "3756",
          "_score" => nil,
          "_source" => {
            "id" => 3756, "name" => "Mary Cohr", "products_count" => 227, "indexed_at" => "2021-10-08T15:02:40.569+00:00"
          },
          "sort" => [227]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "25298",
          "_score" => nil,
          "_source" => {
            "id" => 25298, "name" => "Allure & Style du Monde", "products_count" => 225, "indexed_at" => "2021-10-08T15:03:16.368+00:00"
          },
          "sort" => [225]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "1589",
          "_score" => nil,
          "_source" => {
            "id" => 1589, "name" => "HP", "products_count" => 224, "indexed_at" => "2021-10-08T15:02:36.898+00:00"
          },
          "sort" => [224]
        }, {
          "_index" => "brands_v1_20211008170234192",
          "_type" => "_doc",
          "_id" => "11738",
          "_score" => nil,
          "_source" => {
            "id" => 11738, "name" => "Huawei", "products_count" => 223, "indexed_at" => "2021-10-08T15:02:53.286+00:00"
          },
          "sort" => [223]
        }]
      }
    }
  end
end
