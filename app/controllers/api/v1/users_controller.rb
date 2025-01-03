class Api::V1::UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[show_myprofile]

  def show
    user = User.find_by(name: params[:name])

    if user
      render json: user, serializer: UserDetailsSerializer, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def show_myprofile
    if @user
      render json: @user, serializer: MyprofileSerializer, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def check_name
    user_name = params[:name]
    if user_name.present?
      is_unique = User.where(name: user_name).empty?
      render json: { is_unique: is_unique }
    end
  end

  def followings
    user = User.find_by(name: params[:name])
    followings = user.following_users
    render json: followings
  end

  def followers
    user = User.find_by(name: params[:name])
    followers = user.follower_users
    render json: followers
  end

  private

  def set_user
    @user = current_api_v1_user
  end
end