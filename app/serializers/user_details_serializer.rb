class UserDetailsSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar_url, :email, :location, :twitter

  has_many :boards, each_serializer: BoardSerializer
  has_many :posts, each_serializer: PostSerializer
  has_many :walks, each_serializer: WalkSerializer

  def avatar_url
    object.avatar.url if object.avatar.present?
  end
end