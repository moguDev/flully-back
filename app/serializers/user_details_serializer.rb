class UserDetailsSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar_url, :email, :location, :twitter

  has_many :boards, each_serializer: BoardSerializer
  has_many :posts, each_serializer: PostSerializer

  def avatar_url
    object.avatar.url if object.avatar.present?
  end
end