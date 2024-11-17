class Checkpoint < ApplicationRecord
  belongs_to :walk
  validates :lat, presence: true
  validates :lng, presence: true
end
