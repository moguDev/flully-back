CarrierWave.configure do |config|
  config.asset_host = "http://localhost:3000"
  config.storage = :file
  config.cache_storage = :file
# end

# CarrierWave.configure do |config|
#     config.fog_credentials = {
#         provider: 'Google',
#         google_project: ENV['GOOGLE_PROJECT'],
#         google_json_key_string: ENV['GOOGLE_JSON_KEY_STRING']
#     }
#     config.fog_directory = ENV['FOG_DIRECTORY']
end