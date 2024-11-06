class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar_url, :email, :location

  def avatar_url
    object.avatar.url if object.avatar.present?
  end
end