class Board < ApplicationRecord
  enum category: { maigo: 0, hogosha: 1, mokugeki: 2 }
  enum status: { unresolved: 0, resolved: 1, closed: 2 }
  enum species: { dog: 0, cat: 1, bird: 2, rabbit: 3, other: 4 }
  mount_uploader :icon, BoardIconUploader

  belongs_to :user
  has_many :board_images, dependent: :destroy

  validates :breed, presence: true
end