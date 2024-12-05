require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 7.1
   
    config.autoload_lib(ignore: %w(assets tasks))
    config.hosts << "flully-back.onrender.com"
    config.api_only = true
    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local

    # セッションミドルウェアを有効化
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_your_app_session'
  end
end
