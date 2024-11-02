class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
    before_action :configure_permitted_parameters

    def update
        super do
          @resource.avatar.attach(account_update_params[:avatar]) if account_update_params[:avatar].present?
        end
    end

  private

  def sign_up_params
    # 新規登録時にアバターを許可
    params.permit(:email, :password, :password_confirmation, :name, :nickname, :avatar)
  end

  def account_update_params
    # アカウント更新時にアバターを許可
    params.permit(:email, :password, :password_confirmation, :name, :nickname, :introduction, :twitter, :location, :avatar)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[avatar])
  end
end
