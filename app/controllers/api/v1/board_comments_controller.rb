class Api::V1::BoardCommentsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create]

  def index
    board_id = params[:board_id]
    comments = BoardComment.where(board_id: board_id).order(created_at: :desc)

    render json: comments, each_serializer: BoardCommentSerializer, status: :ok
  end

  def create
    content = params[:content]
    content_type_class = determine_content_type(content)

    case content_type_class.name
    when "ThreadCommentTextContent"
      comment_content = ThreadCommentTextContent.create!(body: content)
    when "ThreadCommentImageContent"
      comment_content = ThreadCommentImageContent.create!(url: content)
    when "ThreadCommentLocationContent"
      lat = params[:lat]
      lng = params[:lng]
      comment_content = ThreadCommentLocationContent.create!(lat: lat, lng: lng)
    else
      render json: { error: 'Invalid content type' }, status: :unprocessable_entity and return
    end

    comment = @user.board_comments.create!(
      board_id: params[:board_id],
      content_type: content_type_class.name,
      content_id: comment_content.id
    )

    render json: comment, serializer: BoardCommentSerializer, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_user
    @user = current_api_v1_user
  end

  def determine_content_type(content)
    if content.is_a?(String)
      if content.match?(/\.(jpg|jpeg|png|gif|bmp)$/i)
        ThreadCommentImageContent
      else
        ThreadCommentTextContent
      end
    elsif params[:lat].present? && params[:lng].present?
      ThreadCommentLocationContent
    else
      nil
    end
  end
end
