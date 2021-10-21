module Api
  module V1
    class VariantsController < ApplicationController
      before_action :uncrypt_token
      before_action :retrieve_user
      before_action :find_variant
      before_action :check_authorization

      def update
        if params[:files].present?
          params[:files].each do |file|
            next if file.blank?
            raise ApplicationController::UnpermittedParameter.new("Incorrect file format") unless file.is_a?(ActionDispatch::Http::UploadedFile)
            image_dto = Dto::V1::Image::Request.create(image: file)
            image = ::Image.create!(file: image_dto.tempfile)
            @reference.sample.images << image
          end
        end
        @reference.base_price = variant_params[:base_price] if variant_params[:base_price].present?
        @reference.weight = variant_params[:weight] if variant_params[:weight].present?
        @reference.quantity = variant_params[:quantity] if variant_params[:quantity].present?
        @reference.sample.default = variant_params[:is_default] if variant_params[:is_default].present?
        if variant_params[:good_deal].present?
          if @reference.good_deal
            @reference.good_deal.update(variant_params[:good_deal])
          else
            @reference.good_deal = GoodDeal.new(variant_params[:good_deal])
          end
        end
        update_characteristics if params[:characteristics].present?
        @reference.save!

        variant = Dto::V1::Variant::Response.create(@reference)
        render json: variant.to_h, status: :ok
      end

      private

      def variant_params
          return @hash if @hash
          @hash = {}
          @hash[:id] = params.require(:id)
          @hash[:base_price] = params[:basePrice]
          @hash[:weight] = params[:weight]
          @hash[:quantity] = params[:quantity]
          @hash[:is_default] = params[:isDefault]
          if params[:goodDeal].present? && !params[:goodDeal].blank?
            good_deal_params = ActionController::Parameters.new(JSON.parse(params[:goodDeal]))
            @hash[:good_deal] = {}
            @hash[:good_deal][:starts_at] = good_deal_params.require(:startAt)
            @hash[:good_deal][:ends_at] = good_deal_params.require(:endAt)
            @hash[:good_deal][:discount] = good_deal_params.require(:discount)
          end
          @hash[:characteristics] = []
          if params[:characteristics].present?
            JSON.parse(params[:characteristics]).each { |c|
              characteristic_params = ActionController::Parameters.new(c)
              characteristic = {}
              characteristic[:name] = characteristic_params.require(:name)
              characteristic[:value] = characteristic_params.require(:value)
              @hash[:characteristics] << characteristic
            }
          end
          @hash
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

      def update_characteristics
        return unless variant_params[:characteristics].present?
        color_characteristic = variant_params[:characteristics].detect { |char| char[:name] == "color" }
        size_characteristic = variant_params[:characteristics].detect { |char| char[:name] == "size" }

        @reference.color_id = color_characteristic ? ::Color.where(name: color_characteristic[:value]).first_or_create.id : nil
        @reference.size_id = size_characteristic ? ::Size.where(name: size_characteristic[:value]).first_or_create.id : nil
        @reference
      end
    end
  end
end
