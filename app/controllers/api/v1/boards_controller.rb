class Api::V1::BoardsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create]

  def index
    boards = Board.all
    render json: boards
  end

  def show
    board = Board.find(params[:id])
    render json: board
  end

  def nearby_boards
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    radius = 10

    boards = Board.near([lat, lng], radius, units: :km).includes(:user)

    render json: boards, each_serializer: BoardSerializer, status: :ok
  end

  def create
    board_params_with_int = board_params.merge(
      category: params[:category].to_i,
      species: params[:species].to_i
    )

    board = @user.boards.new(board_params_with_int.merge(status: :unresolved))

    if board.save
      if params[:images]
        params[:images].each do |image|
          board.board_images.create(image: image)
        end
      end
      render json: board, status: :created
    else
      render json: { errors: board.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def is_user_bookmarked
    is_bookmarked = @user.bookmarks.exists?(board_id: params[:id])
    render json: { is_bookmarked: is_bookmarked }
  end

  private

  def set_user
    @user = current_api_v1_user
  end

  def board_params
    params.permit(:category, :species, :name, :icon, :breed, :age, :date, :lat, :lng, :is_location_public, :body, :feature, :images)
  end
end