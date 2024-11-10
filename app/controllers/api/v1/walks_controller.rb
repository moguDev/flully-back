class Api::V1::WalksController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[index start finish destroy in_progress]
  before_action :set_user, only: %i[index start finish in_progress]

  def index
    walks = @user.walks
    render json: walks
  end

  def start
    if @user.walks.exists?(finish_time: nil)
      render json: { error: 'A walk is already in progress' }, status: :unprocessable_entity
    else
      walk = @user.walks.build(start_time: DateTime.now)
      if walk.save
        render json: walk, status: :created
      else
        render json: walk.errors, status: :unprocessable_entity
      end
    end
  end

  def finish
    walk = @user.walks.find_by(finish_time: nil)
    if walk
      walk.update(finish_time: DateTime.now)
      render json: walk, status: :ok
    else
      render json: { error: 'No walk in progress to finish' }, status: :not_found
    end
  end

  def in_progress
    walk = @user.walks.find_by(finish_time: nil)
    if walk
      render json: { in_progress: true, walk: walk }, status: :ok
    else
      render json: { in_progress: false }, status: :ok
    end
  end

  def destroy; end

  private

  def set_user
    @user = current_api_v1_user
  end
end