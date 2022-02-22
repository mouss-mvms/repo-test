module Api
  module V1
    module Admin
      class TagsController < AdminsController
        def create
          params_hash = create_params
          dto_tag_request = Dto::V1::Tag::Request.new(params_hash)
          tag = Dao::Tag.create(dto_tag_request: dto_tag_request)
          response = Dto::V1::Tag::Response.create(tag).to_h
          render json: response, status: :created
        end

        private

        def create_params
          hash = {}
          hash[:name] = params.require(:name)
          hash[:status] = params.require(:status)
          hash[:featured] = params[:featured] || false
          if params[:imageId]
            hash[:image_id] = params[:imageId] if Image.find(params[:imageId])
          elsif params[:imageUrl]
            hash[:image_url] = params[:imageUrl]
          end
          hash
        end
      end
    end
  end
end
