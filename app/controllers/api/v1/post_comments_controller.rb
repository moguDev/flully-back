class Api::V1::PostCommentsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create]

  def index
    post_comments = PostComment.where(post_id: params[:post_id])
    render json: post_comments, each_serializer: PostCommentSerializer, status: :ok
  end
  
  def create
    post_comment = @user.post_comments.new(post_comment_params)
    post_comment.post_id = params[:post_id]

    if post_comment.save
      render json: post_comment, each_serializer: PostCommentSerializer, status: :ok
    else
      render json: { errors: post_comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_api_v1_user
  end

  def post_comment_params
    params.require(:post_comment).permit(:body, :post_id)
  end
end