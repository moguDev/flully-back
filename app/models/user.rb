# frozen_string_literal: true

class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :walks, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
end