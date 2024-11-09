class BoardComment < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :content, polymorphic: true
end