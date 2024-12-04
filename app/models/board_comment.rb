class BoardComment < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :content, polymorphic: true

  after_create :create_board_comment_notification

  private

  def create_board_comment_notification
    board_owner = board.user

    return if user_id == board_owner.id

    # 1分以内に同一ユーザーが同一掲示板にコメントしている場合は通知を作成しない
    recent_notification = Notification.where(
      user_id: board_owner.id,
      category: Notification.categories[:board_comment],
      url: "/boards/#{board.id}",
      created_at: 1.minute.ago..Time.current
    ).exists?

    return if recent_notification

    Notification.create!(
      user_id: board_owner.id,
      category: Notification.categories[:board_comment],
      body: "@#{user.name}さん があなたの掲示板にコメントしました。",
      checked: false,
      url: "/boards/#{board.id}"
    )
  end
end