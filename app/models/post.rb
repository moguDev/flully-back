class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader
  reverse_geocoded_by :lat, :lng
  belongs_to :user
  belongs_to :walk, optional: true
  has_many :like, dependent: :destroy
  has_many :post_comment, dependent: :destroy
end
