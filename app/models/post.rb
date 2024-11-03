class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader
  belongs_to :user
  belongs_to :walk, optional: true
end
