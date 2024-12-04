class Follow < ApplicationRecord
  belongs_to :following_user, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'

  validates :following_user_id, presence: true
  validates :followed_user_id, presence: true

  after_create :create_follow_notification

  private

  def create_follow_notification
    following_user = User.find(following_user_id)

    recent_notification = Notification.where(
      user_id: followed_user_id,
      category: Notification.categories[:follow],
      url: "/#{following_user.name}"
    ).where('created_at >= ?', 1.hour.ago).exists?

    unless recent_notification
      Notification.create!(
        user_id: followed_user_id,
        category: Notification.categories[:follow],
        body: "@#{following_user.name}さん があなたをフォローしました。",
        checked: false,
        url: "/#{following_user.name}"
      )
    end
  end
end