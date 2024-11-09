class BoardImage < ApplicationRecord
  belongs_to :board
  mount_uploader :image, BoardImageUploader
end
