class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    # 新規登録時にアバターを許可
    params.permit(:email, :password, :password_confirmation, :name, :nickname, :avatar)
  end

  def account_update_params
    # アカウント更新時にアバターを許可
    params.permit(:email, :password, :password_confirmation, :name, :nickname, :introduction, :twitter, :location, :avatar)
  end
end
