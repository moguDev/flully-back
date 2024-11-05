class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :avatar_url

  def avatar_url
    object.avatar.url if object.avatar.present?
  end
end