module Api
  module V1
    class TagsController < ApplicationController

      DEFAULT_PER_PAGE = 15

      def index
        page = params[:page] || 1
        per_page = params[:limit] || DEFAULT_PER_PAGE
        tags = Kaminari.paginate_array(Tag.all.order(created_at: :desc).to_a).page(page).per(per_page)
        response = { tags: [], page: page, totalPages: tags.total_pages}
        response[:tags] = tags.map { |tag| Dto::V1::Tag::Response.create(tag).to_h }
        render json: response, status: :ok
      end

      def show
        tag = Tag.find(params[:id])
        render json: Dto::V1::Tag::Response.create(tag).to_h, status: :ok
      end
    end
  end
end