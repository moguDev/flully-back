class Board < ApplicationRecord
  enum category: { maigo: 0, hogosha: 1, mokugeki: 2 }
  enum status: { unresolved: 0, resolved: 1, closed: 2 }
  enum species: { dog: 0, cat: 1, bird: 2, rabbit: 3, other: 4 }

  mount_uploader :icon, BoardIconUploader

  belongs_to :user
  has_many :board_images, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :board_comments, dependent: :destroy

  validates :category, presence: true
  validates :species, presence: true
  validates :breed, presence: true, length: { maximum: 16 }
  validates :icon, presence: true
  validates :date, presence: true
  validates :lat, presence: true
  validates :lng, presence: true
  validates :is_location_public, inclusion: { in: [true, false] }

  validates :body, length: { maximum: 128 }
  validates :feature, length: { maximum: 64 }


  # Geocoderによる逆ジオコーディング
  reverse_geocoded_by :lat, :lng

  # latとlngが更新されたときのみ住所を取得
  after_validation :set_location_from_lat_lng, if: :lat_or_lng_changed?

  # カテゴリを日本語に変換
  def category_jp
    case category
    when 'maigo'
      '迷子'
    when 'hogosha'
      '保護'
    when 'mokugeki'
      '目撃'
    else
      '未設定'
    end
  end

  # ステータスを日本語に変換
  def status_jp
    case status
    when 'unresolved'
      '未解決'
    when 'resolved'
      '解決'
    when 'closed'
      '終了'
    else
      '未設定'
    end
  end

  # 種類を日本語に変換
  def species_jp
    case species
    when 'dog'
      '犬'
    when 'cat'
      '猫'
    when 'bird'
      '鳥'
    when 'rabbit'
      'ウサギ'
    when 'other'
      'その他'
    else
      '未設定'
    end
  end

  private

  # latまたはlngが変更されたかどうかをチェック
  def lat_or_lng_changed?
    lat_changed? || lng_changed?
  end

  # latとlngから住所を取得し、locationに設定する
  def set_location_from_lat_lng
    result = Geocoder.search([lat, lng]).first
    self.location = result&.address || "住所が取得できませんでした"
  rescue => e
    Rails.logger.error "Geocoding error: #{e.message}"
    self.location = "住所が取得できませんでした"
  end
end