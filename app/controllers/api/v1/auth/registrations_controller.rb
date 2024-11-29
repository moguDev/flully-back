class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.permit(:email, :password, :password_confirmation, :name, :nickname)
  end

  def account_update_params
    params.permit(:email, :password, :password_confirmation, :name, :nickname, :introduction, :twitter, :location, :avatar)
  end

  public

  def update
    user_setting_params = params.permit(:is_mail_public, :is_location_public)

    ActiveRecord::Base.transaction do
      if @resource.update(account_update_params.except(:is_mail_public, :is_location_public))
        if user_setting_params.present?
          @resource.user_setting.update!(user_setting_params)
        end

        render json: { status: 'success', data: @resource }, status: :ok
      else
        render json: { status: 'error', errors: @resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue => e
    render json: { status: 'error', message: e.message }, status: :internal_server_error
  end
end
