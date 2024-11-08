class Api::V1::BookmarksController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create]

  def create
    board = Board.find(params[:id])
    bookmark = board.bookmarks.build(user_id: @user.id)

    if bookmark.save
      render json: bookmark, status: :created
    else
      render json: { errors: 'already bookmarded' }, status: :unprocessable_entity
    end
  end

  def destroy
    bookmark = @user.bookmarks.find_by(board_id: params[:id])

    if bookmark.present?
      bookmark.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete bookmark' }, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = current_api_v1_user
  end
end