class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  skip_before_action :set_user_by_token, raise: false

  def redirect_callbacks
    auth_info = request.env['omniauth.auth'].info
    auth_uid = request.env['omniauth.auth'].uid
    auth_provider = request.env['omniauth.auth'].provider

    # ユーザーを検索、存在しない場合は作成
    @resource = User.find_or_initialize_by(email: auth_info['email'])
    if @resource.new_record?
      @resource.provider = auth_provider
      @resource.uid = auth_uid
      @resource.name = "User_#{SecureRandom.hex(4)}"
      @resource.nickname = auth_info['name']
      @resource.avatar = auth_info['image']
      @resource.password = SecureRandom.urlsafe_base64(12) # ランダムパスワードを設定
      @resource.save!
    end

    # トークン生成
    token = @resource.create_token
    @resource.save!

    # リダイレクトURLを生成
    redirect_url = "#{ENV['FRONTEND_URL']}/auth/callback"
    redirect_params = {
      "access-token": token.token,
      client: token.client,
      uid: @resource.uid,
    }.to_query

    redirect_to "#{redirect_url}?#{redirect_params}", status: 307
  end

  private

  def validate_auth_origin_url_param
    true
  end
end
