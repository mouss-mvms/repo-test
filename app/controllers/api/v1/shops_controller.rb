module Api
  module V1
    class ShopsController < ApplicationController
      before_action :uncrypt_token, except: [:show, :index]
      before_action :retrieve_user, except: [:show, :index]
      before_action :check_user, except: [:show, :index]
      before_action :retrieve_shop, only: [:update]
      before_action :is_shop_owner, only: [:update]

      DEFAULT_FILTERS_SHOPS = [:brands, :services, :categories]
      PER_PAGE = 15

      def index
        search_criterias = ::Criterias::Composite.new(::Criterias::Shops::WithOnlineProducts)
                                                 .and(::Criterias::Shops::NotDeleted)
                                                 .and(::Criterias::Shops::NotTemplated)
                                                 .and(::Criterias::NotInHolidays)

        search_criterias = filter_by(search_criterias)
        category = nil
        if params[:categories]
          category = Category.find_by(slug: params[:categories])
          search_criterias.and(::Criterias::InCategories.new([category.id]))
        end

        if params[:city]
          territory = Territory.find_by(slug: params[:city])
          city = City.find_by(slug: params[:city])
          if territory.nil? && city.nil?
            search_criterias.and(::Criterias::InTerritory.new(''))
          else
            insee_codes = territory ? territory.insee_codes : city.insee_codes
            if params[:q].blank? && category.nil?
              search_criterias.and(::Criterias::InCities.new(insee_codes))
            else
              case params[:perimeter]
              when "around_me" then search_criterias.and(::Criterias::CloseToYou.new(city, insee_codes, current_cities_accepted: true))
              when "all" then search_criterias.and(::Criterias::HasServices.new(["livraison-par-colissimo"]))
              else search_criterias.and(::Criterias::InCities.new(insee_codes))
              end
            end
          end
        end
        response = []

        shops = ::Requests::ShopSearches.search_highest_scored_shops(params[:q], search_criterias)
        if !params[:page] || params[:page] == "1"
          shops.each do |shop|
            response << Dto::V1::Shop::Response.from_searchkick(shop).to_h
          end
        end
        slugs = shops.pluck(:slug)
        search_criterias.and(::Criterias::Shops::ExceptShops.new(slugs))

        random_shops = ::Requests::ShopSearches.search_random_shops(params[:q], search_criterias, params[:page])

        random_shops.each do |random_shop|
          response << Dto::V1::Shop::Response.from_searchkick(random_shop).to_h
        end
        return render json: response, status: :ok
      end

      def show
        raise ActionController::BadRequest.new("#{params[:id]} is not an id valid") unless params[:id].to_i > 0
        shop = Shop.find(params[:id].to_i)

        response = Dto::V1::Shop::Response.create(shop)
        render json: response.to_h, status: :ok
      end

      def create
        shop_request = Dto::V1::Shop::Request.new(shop_params)
        ActiveRecord::Base.transaction do
          shop = Dto::V1::Shop.build(dto_shop_request: shop_request)
          shop.assign_ownership(@user)
          shop.save!
          response = Dto::V1::Shop::Response.create(shop).to_h
          return render json: response.to_h, status: :created
        end
      end

      def update
        shop_request = Dto::V1::Shop::Request.new(shop_params)
        ActiveRecord::Base.transaction do
          shop = Dto::V1::Shop.build(dto_shop_request: shop_request, shop: @shop)
          response = Dto::V1::Shop::Response.create(shop).to_h
          return render json: response.to_h, status: :ok
        end
      end

      private

      def retrieve_shop
        raise ActionController::BadRequest.new('Shop_id is incorrect') unless params[:id].to_i > 0
        @shop = Shop.find(params[:id])
      end

      def shop_params
        shop_params = {}
        shop_params[:name] = params.require(:name)
        shop_params[:email] = params.require(:email)
        shop_params[:siret] = params.require(:siret)
        shop_params[:description] = params[:description]
        shop_params[:baseline] = params[:baseline]
        shop_params[:facebook_link] = params[:facebookLink]
        shop_params[:instagram_link] = params[:instagramLink]
        shop_params[:website_link] = params[:websiteLink]
        shop_params[:address] = {}
        shop_params[:address][:street_number] = params.require(:address).permit(:streetNumber).values.first
        shop_params[:address][:route] = params.require(:address).permit(:route).values.first
        shop_params[:address][:locality] = params.require(:address).permit(:locality).values.first
        shop_params[:address][:country] = params.require(:address).permit(:country).values.first
        shop_params[:address][:postal_code] = params.require(:address).permit(:postalCode).values.first
        shop_params[:address][:latitude] = params.require(:address).permit(:latitude).values.first
        shop_params[:address][:longitude] = params.require(:address).permit(:longitude).values.first
        shop_params[:address][:insee_code] = params.require(:address).require(:inseeCode)
        return shop_params
      end

      def check_user
        raise ApplicationController::Forbidden unless @user.is_a_business_user?
      end

      def is_shop_owner
        raise ApplicationController::Forbidden unless @shop.owner == @user.shop_employee
      end

      def filter_by(search_criterias)
        DEFAULT_FILTERS_SHOPS.each do |key|
          splited_values = params[key.to_s]&.split('__')
          if splited_values
            splited_values = splited_values.map { |value| value == "without_#{key.to_s}" ? "" : value }
            module_name = key.to_s.titleize
            begin
              search_criterias.and("::Criterias::Shops::From#{module_name}".constantize.new(splited_values))
            rescue; end
          end
        end
        search_criterias
      end
    end
  end
end
