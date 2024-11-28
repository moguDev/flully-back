class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  extend Devise::Models
  after_create :create_default_user_setting
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :board_comments, dependent: :destroy
  has_one :user_setting, dependent: :destroy

  has_many :follows_as_follower, foreign_key: :following_user_id, class_name: 'Follow'
  has_many :following_users, through: :follows_as_follower, source: :followed_user
  has_many :follows_as_followed, foreign_key: :followed_user_id, class_name: 'Follow'
  has_many :follower_users, through: :follows_as_followed, source: :following_user

  validates :name, length: { minimum:4, maximum:16 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :nickname, length: { minimum:2, maximum:32 }
  validates :introduction, length: { maximum: 128 }
  validates :location, length: { maximum: 64 }
  validates :twitter, length: { maximum: 128 }

  private

  def create_default_user_setting
    create_user_setting(is_mail_public: false, is_location_public: false)
  end
end
