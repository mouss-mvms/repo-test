module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        @categories = Category.search('*', load: false)
        categories_response = []
        parent_categories = Category.search('*', {where: {parent_id: nil}, page: params[:page], per_page: 1,  load: false})
        parent_categories.each do |parent_category|
          parent_category_response = Dto::V1::Category::Response.new({id: parent_category.id, name: parent_category.name, slug: parent_category.slug})
          categories_response << build_children_category_response(parent_category_response)
        end
        render json: { categories: categories_response, page: parent_categories.options[:page]}
      end

      private

      def build_children_category_response(parent_category_response)
        children_categories = @categories.select{|cc| cc[:parent_id] == parent_category_response.id}
        children_categories.each do |child_category|
          child_category_response = Dto::V1::Category::Response.new({id: child_category.id, name: child_category.name, slug: child_category.slug})
          parent_category_response.children << build_children_category_response(child_category_response)
        end
        return parent_category_response
      end
    end
  end
end
