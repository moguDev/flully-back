class PostCommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :user

  def user
    UserSerializer.new(object.user).as_json
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