class Api::V1::Auth::TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  def validate_token
    if @resource
      render json: @resource, each_serializer: UserSerializer, status: :ok
    else
      render json: { success: false }, status: :unauthorized
    end
  end
end