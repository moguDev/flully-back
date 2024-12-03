class PostSerializer < ActiveModel::Serializer
  attributes :id, :body, :lat, :lng, :is_anonymous, :image_url, :formated_date, :created_at, :user, :like_count

  def image_url
    object.image.url if object.image.present?
  end

  def user
    return nil if object.is_anonymous

    UserSerializer.new(object.user).as_json
  end

  def like_count
    object.likes.count
  end

  def formated_date
    local_time = object.created_at.in_time_zone("Asia/Tokyo")
    
    if local_time.to_date == Date.today
      "今日 #{local_time.strftime('%H:%M')}"
    else
      local_time.strftime('%Y年%m月%d日 %H:%M')
    end
  end
end