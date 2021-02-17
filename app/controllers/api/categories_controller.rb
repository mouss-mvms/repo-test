class Api::CategoriesController < ApplicationController
  def index
    categories = []
    render json: categories
  end
end
