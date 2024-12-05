source "https://rubygems.org"
git_source(:github) {|repo| "https://github.com/#{repo}.git" }

ruby "3.3.3"

gem "bootsnap", require: false

gem "pg", "~> 1.1"

gem "puma", "~> 6.4.0"

gem "rails", "~> 7.1.2"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "rack-cors", "~> 2.0.1"

gem 'devise'
gem 'devise_token_auth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

gem 'carrierwave'
gem 'fog-aws'
gem 'mini_magick'

gem 'dotenv-rails'

gem 'geocoder'

gem 'active_model_serializers'

gem 'letter_opener', group: :development

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false # Rails専用ルールを適用する場合
end
