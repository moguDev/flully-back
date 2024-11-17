class Walk < ApplicationRecord
  belongs_to :user
  has_many :checkpoints, dependent: :destroy
  has_many :posts
  validates :start_time, presence: true
end
