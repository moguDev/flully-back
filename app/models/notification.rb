class Notification < ApplicationRecord
  belongs_to :user

  enum category: { follow: 1, like: 2, post_comment: 3, board_comment: 4 }
end