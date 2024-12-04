class Api::V1::NotificationsController < ApplicationController
  before_action :set_user
  before_action :authenticate_api_v1_user!

  def index
    notifications = @user.notifications.order(id: :desc)
    render json: notifications
  end

  def unread
    unread_count = @user.notifications.where(checked: false).count
    render json: { unread: unread_count }
  end

  def checked
    notification = @user.notifications.find(params[:id])
    if notification
      notification.update!(checked: true)
      render json: { success: true, message: 'Notification marked as read' }
    else
      render json: { success: false, message: 'Notification not found' }, status: :not_found
    end
  end

  private
  
  def set_user
    @user = current_api_v1_user
  end
end