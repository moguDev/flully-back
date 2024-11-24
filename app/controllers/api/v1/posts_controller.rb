class Api::V1::PostsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create is_user_liked destroy]

  def index
    posts = Post.all
    render json: posts
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
    current_walk = @user.walks.find_by(finish_time: nil)

    if current_walk
      post = @user.posts.new(
        post_params.merge(walk_id: current_walk&.id)
      )
    else
      post = @user.posts.new(post_params)
    end

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

  def destroy
    post = @user.posts.find(params[:id])

    if post
      post.destroy
      render json: { message: "Post deleted successfully" }, status: :ok
    else
      render json: { error: "Post not found or not authorized to delete" }, status: :not_found
    end
  end

  private

  def set_user
    @user = current_api_v1_user
  end

  def post_params
    params.require(:post).permit(:body, :lat, :lng, :is_anonymous, :image)
  end
end