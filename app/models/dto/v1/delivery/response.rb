module Dto
  module V1
    module Delivery
      class Response
        attr_reader :id, :name, :slug, :description, :public_description, :detailed_public_description, :is_express, :is_shop_dependent, :is_delivery

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @description = args[:description]
          @public_description = args[:public_description]
          @detailed_public_description = args[:detailed_public_description]
          @is_express = args[:is_express]
          @is_shop_dependent = args[:is_shop_dependent]
          @is_delivery = args[:is_delivery]
        end

        def self.create(delivery)
          Dto::V1::Delivery::Response.new({id: delivery.id,
                                           name: delivery.name,
                                           slug: delivery.slug,
                                           description: delivery.description,
                                           public_description: delivery.public_description,
                                           detailed_public_description: delivery.detailed_public_description,
                                           is_express: delivery.express,
                                           is_shop_dependent: delivery.shop_dependent,
                                           is_delivery: delivery.is_delivery,})
        end

        def to_h
          {
            id: @id,
            name: @name,
            slug: @slug,
            description: @description,
            publicDescription: @public_description,
            detailedPublicDescription: @detailed_public_description,
            isExpress: @is_express,
            isShopDependent: @is_shop_dependent,
            isDelivery: @is_delivery
          }
        end
      end
    end
  end
end
