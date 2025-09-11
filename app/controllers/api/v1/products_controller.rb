class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[update destroy create ]

  def index
    products = Product.all
    render json: products
  end

  def show
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: product.errors.full_message, status: 422
    end
  end

  def update
    if @product.update(set_product)
      render json: @product, status: :ok
    else
      render json: product.errors.full_message, status: 422
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
