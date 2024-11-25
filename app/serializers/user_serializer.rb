class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :introduction, :avatar, :email, :location, :twitter

  def email
    is_mail_public = object.user_setting.is_mail_public
    if is_mail_public
      object.email
    else
      nil
    end
  end

  def location
    is_location_public = object.user_setting.is_location_public
    if is_location_public
      object.location
    else
      "非公開"
    end
  end
end
