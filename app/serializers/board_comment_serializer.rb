class BoardCommentSerializer < ActiveModel::Serializer
  attributes :id, :user, :board_id, :content_type, :content, :created_at

  def user
    UserSerializer.new(object.user)
  end

  def content
    content_type_class = object.content_type.constantize

    case content_type_class.name
    when "ThreadCommentTextContent"
      content_type_class.find(object.content_id).body
    when "ThreadCommentImageContent"
      content_type_class.find(object.content_id).url
    when "ThreadCommentLocationContent"
      content_type_class.find(object.content_id).slice(:lat, :lng)
    else
      nil
    end
  end

  def content_type
    content_type_class = object.content_type.constantize

    case content_type_class.name
    when "ThreadCommentTextContent"
      "text"
    when "ThreadCommentImageContent"
      "image"
    when "ThreadCommentLocationContent"
      "location"
    else
      nil
    end
  end

  def created_at
    local_time = object.created_at.in_time_zone("Asia/Tokyo")
    if local_time.to_date == Date.today
      "今日 #{local_time.strftime('%H:%M')}"
    else
      local_time.strftime('%m月%d日 %H:%M')
    end
  end
end