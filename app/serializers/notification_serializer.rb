class NotificationSerializer < ActiveModel::Serializer
  attributes :user_id, :category, :body, :checked, :url, :created_at

  def created_at
    local_time = object.created_at.in_time_zone("Asia/Tokyo")
    
    if local_time.to_date == Date.today
      "今日 #{local_time.strftime('%H:%M')}"
    else
      local_time.strftime('%m月%d日 %H:%M')
    end
  end
end