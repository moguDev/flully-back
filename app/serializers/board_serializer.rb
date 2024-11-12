class BoardSerializer < ActiveModel::Serializer
  attributes :id, :category, :species, :status, :name, :icon_url, :age, :formated_date, :date, :lat, :lng, :location, :is_location_public, :body, :feature, :created_at, :updated_at, :breed, :user, :bookmark_count, :images

  # iconをicon_urlに変換
  def icon_url
    object.icon.url
  end

  # user_idをuser情報として返す
  def user
    UserSerializer.new(object.user)
  end

  # categoryを日本語に変換して返す
  def category
    object.category_jp
  end

  # speciesを日本語に変換して返す
  def species
    object.species_jp
  end

  # statusを日本語に変換して返す
  def status
    object.status_jp
  end

  # locationを都道府県・市区町村・町名の形式で返却（空白を除去）
  def location
    if object.is_location_public?
      if object.location.present?
        match_data = object.location.match(/[^\d〒、]*[都道府県][^市区町村]*[市区町村][^町]*町?/)
        match_data ? match_data[0].delete(" ") : "住所が取得できませんでした"
      else
        "住所が取得できませんでした"
      end
    else
      if object.location.present?
        match_data = object.location.match(/[^\d〒、]*[都道府県][^市区町村]*[市区町村]/)
        match_data ? match_data[0].delete(" ") : "住所が取得できませんでした"
      else
        "住所が取得できませんでした"
      end
    end
  end

  # latを返す。is_location_publicがfalseの場合はnullを返す
  def lat
    object.is_location_public? ? object.lat : nil
  end

  # lngを返す。is_location_publicがfalseの場合はnullを返す
  def lng
    object.is_location_public? ? object.lng : nil
  end

  # dateをyyyy年mm月dd日 hh:mm形式で返却
  def formated_date
    object.date.strftime("%Y年%m月%d日 %H:%M") if object.date.present?
  end

  # bookmark_countを返す
  def bookmark_count
    object.bookmarks.count
  end

  # imagesを返す
  def images
    object.board_images.map { |board_image| board_image.image.url }
  end
end