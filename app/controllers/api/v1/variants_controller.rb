module Api
  module V1
    class VariantsController < ApplicationController
      before_action :uncrypt_token, only: [:update]
      before_action :retrieve_user, only: [:update]
      before_action :find_variant
      before_action :check_authorization, only: [:update]

      def update
        dto_variant_request = Dto::V1::Variant::Request.new(variant_params)
        reference = Dao::Variant.update(dto_variant_request: dto_variant_request)
        variant = Dto::V1::Variant::Response.create(reference)
        render json: variant.to_h, status: :ok
      end

      def update_offline
        raise ApplicationController::UnprocessableEntity.new("Variant should have external provider.") unless @reference.api_provider_variant.present?
        dto_variant_request = Dto::V1::Variant::Request.new(variant_params)
        reference = Dao::Variant.update(dto_variant_request: dto_variant_request)
        variant = Dto::V1::Variant::Response.create(reference)
        render json: variant.to_h, status: :ok
      end

      private

      def variant_params
          hash = {}
          hash[:id] = params.require(:id)
          hash[:base_price] = params[:basePrice]
          hash[:weight] = params[:weight]
          hash[:quantity] = params[:quantity]
          hash[:is_default] = params[:isDefault]
          hash[:image_urls] = params[:imageUrls]
          if params[:goodDeal]
            good_deal_params = ActionController::Parameters.new(JSON.parse(params[:goodDeal]))
            hash[:good_deal] = {}
            hash[:good_deal][:start_at] = good_deal_params.require(:startAt)
            hash[:good_deal][:end_at] = good_deal_params.require(:endAt)
            hash[:good_deal][:discount] = good_deal_params.require(:discount)
          end
          hash[:characteristics] = []
          if params[:characteristics].present?
            JSON.parse(params[:characteristics]).each { |c|
              characteristic_params = ActionController::Parameters.new(c)
              characteristic = {}
              characteristic[:name] = characteristic_params.require(:name)
              characteristic[:value] = characteristic_params.require(:value)
              hash[:characteristics] << characteristic
            }
          end
          hash[:external_variant_id] = params[:externalVariantId]
          hash[:files] = params[:files]
          hash
      end

      def check_authorization
        if @user.is_a_citizen?
          raise ApplicationController::Forbidden if @user.citizen.products.to_a.find { |p| p.id == @reference.product.id }.nil?
        elsif @user.is_a_business_user?
          raise ApplicationController::Forbidden if @user.shop_employee.shops.to_a.find { |s| s.id == @reference.product.shop.id }.nil?
        else
          raise ApplicationController::Forbidden
        end
      end

      def find_variant
        @reference = Reference.find(params[:id])
      end

      def update_characteristics(dto_variant_request:)
        return unless dto_variant_request.characteristics
        color_characteristic = dto_variant_request.characteristics.detect { |char| char.name == "color" }
        size_characteristic = dto_variant_request.characteristics.detect { |char| char.name == "size" }

        @reference.color_id = color_characteristic ? ::Color.where(name: color_characteristic.value).first_or_create.id : nil
        @reference.size_id = size_characteristic ? ::Size.where(name: size_characteristic.value).first_or_create.id : nil
        @reference
      end
    end
  end
end
