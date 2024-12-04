class Api::V1::NotificationsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!

  def index
    notifications = @user.notifications.order(created_at: :desc)
    render json: notifications
  end

  def unread
    unread_count = @user.notifications.where(checked: false).count
    render json: { unread: unread_count }
  end

  private
  
  def set_user
    @user = current_api_v1_user
  end
end