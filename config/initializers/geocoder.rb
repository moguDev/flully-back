# config/initializers/geocoder.rb
Geocoder.configure(
  timeout: 5,                 # リクエストのタイムアウト時間
  units: :km,                 # 距離単位
  lookup: :google,            # Google Maps APIを使用
  api_key: ENV['GOOGLE_MAPS_API_KEY'],  # 環境変数からAPIキーを取得
  language: :ja               # 応答を日本語で取得
)