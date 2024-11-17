class ThreadCommentTextContent < ApplicationRecord
  has_many :board_comments, as: :content
  validates :body, presence :true, length: { maximum:128 }
end