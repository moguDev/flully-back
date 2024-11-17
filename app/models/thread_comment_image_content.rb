class ThreadCommentImageContent < ApplicationRecord
  has_many :board_comments, as: :content
  mount_uploader :url, BoardCommentImageUploader
  validates :url, presence: true
end