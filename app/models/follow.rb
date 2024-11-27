class Follow < ApplicationRecord
  belongs_to :following_user, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'

  validates :following_user_id, presence: true
  validates :followed_user_id, presence: true
end