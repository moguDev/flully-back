class MyprofileSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar, :email, :location, :twitter, :is_mail_public, :is_location_public

  def is_mail_public
    object.user_setting.is_mail_public
  end

  def is_location_public
    object.user_setting.is_location_public
  end
end
