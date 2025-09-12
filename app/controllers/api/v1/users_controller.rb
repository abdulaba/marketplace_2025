class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %w[show update destroy]

  def index
    @users = User.all
    render json: UserSerializer.new(@users).serializable_hash, status: 200
  end

  def show; end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: UserSerializer.new(@user).serializable_hash, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
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
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Usuario no encontrado" }, status: :not_found
  end
end
