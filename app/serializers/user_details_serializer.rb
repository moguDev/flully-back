class UserDetailsSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar, :email, :location, :twitter, :following_count, :followers_count

  has_many :boards, each_serializer: BoardSerializer
  has_many :posts, each_serializer: PostSerializer
  
  def email
    is_mail_public = object.user_setting.is_mail_public
    if is_mail_public
      object.email
    else
      nil
    end
  end

  def location
    is_location_public = object.user_setting.is_location_public
    if is_location_public
      object.location
    else
      "非公開"
    end
  end

  def following_count
    object.following_users.count
  end

  def followers_count
    object.follower_users.count
  end
end