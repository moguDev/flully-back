class PostSerializer < ActiveModel::Serializer
  attributes :id, :body, :lat, :lng, :is_anonymous, :image_url, :created_at, :user

  def image_url
    object.image.url if object.image.present?
  end

  def user
    return nil if object.is_anonymous

    UserSerializer.new(object.user).as_json
  end
end