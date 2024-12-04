class Api::V1::Auth::PasswordsController < DeviseTokenAuth::PasswordsController
  # パスワードリセットの作成
  def create
    # emailパラメータがなければ失敗で返却
    return render_create_error_missing_email unless resource_params[:email]

    # 大文字小文字を区別せずパラメーターからemailを取得
    @email = get_case_insensitive_field_from_resource_params(:email)
    # emailからUserを取得
    @resource = User.find_by(email: @email) if @email

    # ユーザーがいるかどうか
    # あるいはユーザーがブロックで渡されているかどうか
    if @resource
      yield @resource if block_given?
      
      # ユーザーがブロックで渡されていたらリセットパスワードのトークンを作成し
      # SESへメール送信
      @resource.send_reset_password_instructions(
        email: @email,
        provider: 'email',
        redirect_url: @redirect_url,
        client_config: params[:config_name]
      )

      # メール送信でエラーが発生していないか
      if @resource.errors.empty?
        # パスワードリセット申請メールの送信完了を返却
        return render_create_success
      else
	    # メール送信のエラーを返却
        render_create_error @resource.errors
      end
    else
	# ユーザーが見つからないエラーを返却
      render_not_found_error
    end
  end

  # パスワード更新
  # ユーザーから送られてきた新しいパスワードを更新する
  def update
	# パスワートリセット用のトークンが必要かどうか
	# また、パスワードリセット用のトークンがあるか
    if require_client_password_reset_token? && resource_params[:reset_password_token]
      # リセットパスワードのトークンをもとにユーザーを検索
      @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])
      # ユーザーがいなければ認証失敗
      return render_update_error_unauthorized unless @resource

      # ユーザーがいればトークンを作成
      @token = @resource.create_token
    else
	  # パスワードリセット用のトークンが不要またはパスワードリセット用のトークンがないときは
	  # トークンを生成
      @resource = set_user_by_token
    end

    # ユーザーがいなければ認証失敗
    return render_update_error_unauthorized unless @resource
	
    # メール認証していない場合は認証テーブルを確認
    unless @resource.provider == 'email'
	  # ユーザーの認証テーブルからemail認証があるかどうか
      email_auth = @resource.authentications.find_by(provider: 'email')
	  # emailの認証データがない = SNS認証しか行っていない場合
      unless email_auth.present?
        # emailのプロバイダーで認証データを作成
        @resource.authentications.create!(provider: 'email', uid: @resource.email)
      end
	  # ユーザーのプロバイダーにemailを設定
	  # SNSのプロバイダーだとパスワードリセットができないため
      @resource.provider = 'email'
    end

    # パスワードとパスワード確認のパラメータがあるか
    unless password_resource_params[:password] && password_resource_params[:password_confirmation]
      # なければ更新失敗を返却
      return render_update_error_missing_password
    end

    # パスワードを更新
    if @resource.send(resource_update_method, password_resource_params)
	  # パスワード再設定ができるのであれば、既存パスワードの確認をはずす
      @resource.allow_password_change = false if recoverable_enabled?
      # 新しいパスワードで保存
      @resource.save!
			
      # ユーザーがブロックで渡されていたら更新成功を返却
      yield @resource if block_given?
      return render_update_success
    else
	  # パスワード更新ができなければエラーを返却
      return render_update_error
    end
  end

  private

  # 更新成功のオーバーライド
  def render_update_success
    # 自動ログイン
    sign_in(@resource)

    # トークンを生成
    client_id   = SecureRandom.urlsafe_base64(nil, false)
    token       = SecureRandom.urlsafe_base64(nil, false)
    token_hash  = BCrypt::Password.create(token)
    expiry      = (Time.now + DeviseTokenAuth.token_lifespan).to_i

    @resource.tokens[client_id] = {
      token:  token_hash,
      expiry: expiry
    }

    # 新しいトークンを保存
    @resource.save!

    # ヘッダーにトークン情報を含める
    response.headers['Uid'] = @resource.uid
    response.headers['Client'] = client_id
    response.headers['Expiry'] = expiry
    response.headers['Access-Token'] = token

    # パスワード更新成功のフラグとメッセージを返却
    render json: {
      success: true,
      message: I18n.t('devise_token_auth.passwords.successfully_updated')
    }
  end

  def redirect_options
    {
      allow_other_host: true
    }
  end
end
