class Api::V1::CheckpointsController < ApplicationController
  def create
    walk = Walk.find_by(user_id: current_user.id, finish_time: nil)

    unless walk
      render json: { status: 'error', message: 'Currently no active walk found' }, status: :not_found
      return
    end

    # 取得したwalkに関連付けて新しいcheckpointを作成
    checkpoint = walk.checkpoints.new(lat: params[:lat], lng: params[:lng])

    if checkpoint.save
      render json: { status: 'success', checkpoint: checkpoint }, status: :created
    else
      render json: { status: 'error', errors: checkpoint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def checkpoint_params
    params.require(:checkpoint).permit(:lat, :lng)
  end
end