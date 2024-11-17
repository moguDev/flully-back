class MyprofileSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar_url, :email, :location, :twitter, :is_mail_public, :is_location_public

  def avatar_url
    object.avatar.url if object.avatar.present?
  end

  def is_mail_public
    object.user_setting.is_mail_public
  end

  def is_location_public
    object.user_setting.is_location_public
  end
end
