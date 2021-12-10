module Api
  module V1
    module Admin
      class TagsController < AdminsController
        def create
          params_hash = create_params
          tag = Tag.create!(params_hash)
          response = Dto::V1::Tag::Response.create(tag).to_h
          render json: response, status: :created
        end

        private

        def create_params
          hash = {}
          hash[:name] = params.require(:name)
          hash[:status] = params.require(:status)
          hash[:featured] = params[:featured] || false
          hash[:image_url] = params[:imageUrl]
          hash
        end
      end
    end
  end
end
