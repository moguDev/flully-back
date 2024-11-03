class Api::V1::PostsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    # 現在の散歩があるか確認 (finish_timeがnilのものが散歩中)
    current_walk = current_api_v1_user.walks.find_by(finish_time: nil)

    # 散歩中ならwalk_idを設定し、そうでなければnilを設定
    post = current_api_v1_user.posts.new(
      post_params.merge(walk_id: current_walk&.id)
    )

    if post.save
      render json: { message: 'Post created successfully', post: post }, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :lat, :lng, :is_anonymous, :image)
  end
end