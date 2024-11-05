class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader
  reverse_geocoded_by :lat, :lng
  belongs_to :user
  belongs_to :walk, optional: true
  has_many :likes, dependent: :destroy
  has_many :post_comments, dependent: :destroy
end