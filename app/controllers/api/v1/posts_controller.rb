class Api::V1::PostsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def nearby_posts
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    radius = 10

    # 距離検索を行い、ユーザー情報と共に投稿データを整形
    posts = Post.near([lat, lng], radius, units: :km).includes(:user).map do |post|
      {
        id: post.id,
        body: post.body,
        lat: post.lat,
        lng: post.lng,
        is_anonymous: post.is_anonymous,
        image_url: post.image.url,
        created_at: post.created_at,
        user: post.is_anonymous ? nil : {
          id: post.user.id,
          name: post.user.name,
          nickname: post.user.nickname,
          avatar_url: post.user.avatar.url
        }
      }
    end

    render json: { posts: posts }, status: :ok
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

  private

  def post_params
    params.require(:post).permit(:body, :lat, :lng, :is_anonymous, :image)
  end
end