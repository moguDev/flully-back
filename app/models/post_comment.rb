class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { maximum: 64 }

  after_create :create_comment_notification

  private

  def create_comment_notification
    post_owner = post.user

    return if user_id == post_owner.id

    # 同一ユーザーから同一ポストへの通知が1分以内に作成されているか確認
    recent_notification = Notification.where(
      user_id: post_owner.id,
      category: Notification.categories[:post_comment],
      url: "/map?post_id=#{post_id}"
    ).where('created_at >= ?', 1.minute.ago).exists?

    # 通知をスキップする条件を満たさない場合のみ通知を作成
    unless recent_notification
      Notification.create!(
        user_id: post_owner.id,
        category: Notification.categories[:post_comment],
        body: "@#{user.name}さん があなたのみつけた動物にコメントしました。",
        checked: false,
        url: "/map?post_id=#{post_id}"
      )
    end
  end
end