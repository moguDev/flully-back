class Api::V1::PostsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create is_user_liked]

  def nearby_posts
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    radius = 10

    posts = Post.near([lat, lng], radius, units: :km).includes(:user)

    render json: posts, each_serializer: PostSerializer, status: :ok
  end

  def show
    post = Post.find(params[:id])

    if post
      render json: post, each_serializer: PostSerializer, status: :ok
    else
      render json: { error: "Post not found" }, status: :not_found
    end
  end

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

  def is_user_liked
    is_liked = @user.likes.exists?(post_id: params[:id])
    render json: { is_liked: is_liked }
  end

  private

  def set_user
    @user = current_api_v1_user
  end

  def post_params
    params.require(:post).permit(:body, :lat, :lng, :is_anonymous, :image)
  end
end