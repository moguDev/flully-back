class ThreadCommentLocationContent < ApplicationRecord
  has_many :board_comments, as: :content
  validates :lat, presence: true
  validates :lng, presence: true
end