class PostSerializer < ActiveModel::Serializer
  attributes :id, :body, :lat, :lng, :is_anonymous, :image_url, :created_at, :user, :like_count

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

  def created_at
    # 日本時間に変換
    local_time = object.created_at.in_time_zone("Asia/Tokyo")
    
    # 当日の場合
    if local_time.to_date == Date.today
      "今日 #{local_time.strftime('%H:%M')}"
    else
      local_time.strftime('%m月%d日 %H:%M')
    end
  end
end