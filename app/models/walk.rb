class Walk < ApplicationRecord
  belongs_to :user
  has_many :checkpoints, dependent: :destroy
end
