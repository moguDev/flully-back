module Api
  module V1
    class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
      def google
        # Googleからアクセストークンを取得し、ユーザーを認証または作成
        auth_info = request.env['omniauth.auth']
        user = User.find_or_initialize_by(email: auth_info.info.email)

        if user.persisted?
          token = user.create_token
          render json: { user: user, token: token }, status: :ok
        else
          render json: { error: 'ユーザー認証に失敗しました' }, status: :unauthorized
        end
      end

      def omniauth_success
        super
      end
    end
  end
end