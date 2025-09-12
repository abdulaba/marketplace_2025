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
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize_product_owner!
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_product_owner!
    @product.destroy
    head :no_content
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Producto no encontrado" }, status: :not_found
  end

  def authorize_product_owner!
    unless @product.user == current_user
      render json: { error: "No autorizado" }, status: :forbidden
    end
  end
end
