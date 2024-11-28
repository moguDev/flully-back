class Api::V1::FollowsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!

  def create
    followed_user = User.find_by(name: params[:name])
    if @user.following_users.exists?(followed_user.id)
      render json: { error: 'You are already following this user' }, status: :unprocessable_entity
    else
      follow = Follow.new(following_user: @user, followed_user: followed_user)
      if follow.save
        render json: { message: 'Followed successfully', follow: follow }, status: :created
      else
        render json: { error: follow.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    followed_user = User.find(params[:id])
    follow = Follow.find_by(following_user: @user, followed_user: followed_user)
    if follow
      follow.destroy
      render json: { message: 'Unfollowed successfully' }, status: :ok
    else
      render json: { error: 'Follow not found' }, status: :not_found
    end
  end

  def check_status
    followed_user = User.find_by(name: params[:name])
    is_following = @user.following_users.exists?(followed_user.id)
    render json: { is_following: is_following }, status: :ok
  end

  private

  def set_user
    @user = current_api_v1_user
  end
end