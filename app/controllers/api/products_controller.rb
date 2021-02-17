class Api::ProductsController < ApplicationController
  def index
    products = []
    render json: products
  end

  def show
    product = {}
    render json: product
  end

  def create
    product = {}
    render json: product
  end
end
