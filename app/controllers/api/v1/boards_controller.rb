class Api::V1::BoardsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!, only: %i[create update]
  before_action :set_board, only: %i[show update]

  def index
    boards = Board.all
    render json: boards
  end

  def show
    render json: @board
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

  def update
    if @board.user_id == @user.id
      board_params_with_int = board_params.merge(
        category: params[:category].to_i,
        species: params[:species].to_i
      )

      if @board.update(board_params_with_int)
        if params[:images]
          params[:images].each do |image|
            @board.board_images.create(image: image)
          end
        end
        if params[:remove_image_id].present?
          image_ids = params[:remove_image_id].split(',').map(&:to_i)

          image_ids.each do |image_id|
            board_image = @board.board_images.find_by(id: image_id)
            board_image&.destroy if board_image
          end
        end
        render json: @board, status: :ok
      else
        render json: { errors: @board.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this board.' }, status: :forbidden
    end
  end

  def search
    keywords = params[:keyword].to_s.strip.split(/\s+/)
    
    boards = Board.all
    keywords.each do |word|
      boards = boards.where(
        "name LIKE :word OR body LIKE :word OR breed LIKE :word OR feature LIKE :word OR location LIKE :word",
        word: "%#{word}%"
      )
    end
    
    render json: boards, each_serializer: BoardSerializer, status: :ok
  end

  private

  def set_user
    @user = current_api_v1_user
  end

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.permit(:category, :species, :name, :icon, :breed, :age, :date, :lat, :lng, :is_location_public, :body, :feature, :images)
  end
end