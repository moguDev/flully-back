class BoardCommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :board_id, :content_type, :content

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
end