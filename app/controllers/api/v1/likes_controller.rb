class Api::V1::LikesController < ApplicationController
  before_action :authenticate_api_v1_user!
end