class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }

  after_create :create_like_notification

  private

  def create_like_notification
    post_owner = post.user

    return if user_id == post_owner.id

    # 同一ユーザーが同一投稿へのいいね通知を10分以内に作成しているか確認
    recent_notification = Notification.where(
      user_id: post_owner.id,
      category: Notification.categories[:like],
      url: "/map?post_id=#{post_id}"
    ).where('created_at >= ?', 10.minutes.ago).exists?

    # 通知が10分以内に存在しない場合のみ作成
    unless recent_notification
      Notification.create!(
        user_id: post_owner.id,
        category: Notification.categories[:like],
        body: "@#{user.name}さん があなたのみつけた動物にいいねしました。",
        checked: false,
        url: "/map?post_id=#{post_id}"
      )
    end
  end
end