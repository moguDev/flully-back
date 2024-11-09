class ThreadCommentTextContent < ApplicationRecord
  has_many :board_comments, as: :content
end