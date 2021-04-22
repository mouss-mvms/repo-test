require_relative '../../dtos/category_dto.rb'

module Api
  class CategoriesController < ApplicationController
    def index
      categories = []
      dto_category1 = CategoryDto.new
      dto_category1.name = "Chaussures"
      dto_category1.id = 1
      dto_category2 = CategoryDto.new
      dto_category2.name = "Jeans"
      dto_category2.id = 2
      dto_category3 = CategoryDto.new
      dto_category3.name = "Vestes"
      dto_category3.id = 3
      categories << dto_category1
      categories << dto_category2
      categories << dto_category3
      render json: categories.to_json
    end
  end
end