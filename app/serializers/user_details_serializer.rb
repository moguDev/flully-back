class UserDetailsSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar_url, :email, :location, :twitter, :following_count, :followers_count, :explore_points, :level

  has_many :boards, each_serializer: BoardSerializer
  has_many :posts, each_serializer: PostSerializer

  def avatar_url
    object.avatar.url || nil
  end
  
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

  def explore_points
    points = 0
    object.posts.each do |post|
      points += 10 + post.likes.length * 2
    end
    return points
  end

  def level
    base_points = 50
    growth_rate = 0.15
    points = explore_points

    level = 1
    while points >= base_points * Math.exp(growth_rate * (level - 1))
      points -= base_points * Math.exp(growth_rate * (level - 1))
      level += 1
    end
    return level
  end
end
