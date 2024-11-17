class UserDetailsSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar_url, :email, :location, :twitter, :current_streak

  has_many :boards, each_serializer: BoardSerializer
  has_many :posts, each_serializer: PostSerializer
  has_many :walks, each_serializer: WalkSerializer

  def avatar_url
    object.avatar.url if object.avatar.present?
  end

  def current_streak
    today = Time.current.in_time_zone('Asia/Tokyo').to_date
    walk_dates = object.walks.map { |walk| walk.start_time.to_date }
    walk_dates = walk_dates.uniq
    streak = 0
    current_date = today

    while walk_dates.include?(current_date)
      streak += 1
      current_date = current_date - 1.day # 前日へ
    end

    streak
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
end