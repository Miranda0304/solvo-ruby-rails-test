class Api::V1::UsersController < ApplicationController
  def index
    users = Users::FindAll.new.call
    render json: users, status: :ok
  end

  def show
    user = Users::Find.new.call(params[:id])
    render json: user, status: :ok
  end

  def create
    user = Users::Create.new.call(user_params)
    render json: user, status: :created
  end

  private

  def user_params
    params.permit(:name, :email, :department, :max_capacity_allowed, :is_admin)
  end
end
