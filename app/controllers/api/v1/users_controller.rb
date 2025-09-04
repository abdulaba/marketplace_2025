class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %w[show update destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show; end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { message: "Error al crear el usuario" }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 201
    else
      render json: { message: "Error al actualizar el usuario" }, status: 400
    end
  end

  def destroy
    @user.destroy
      render json: { message: "Usuario eliminado correctamente" }, status: 200
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
