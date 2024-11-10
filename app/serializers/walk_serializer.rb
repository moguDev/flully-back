class WalkSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :start_time, :finish_time, :checkpoints, :total_distance, :created_at

  has_many :posts, each_serializer: PostSerializer

  def checkpoints
    object.checkpoints
  end

  def total_distance
    calculate_total_distance(object.checkpoints)
  end

  def created_at
    object.created_at.strftime("%Y年%m月%d日")
  end

  private

  # Haversine公式を使用して2地点間の距離を計算するメソッド（キロメートル単位）
  def haversine_distance(lat1, lng1, lat2, lng2)
    radius = 6371.0 # 地球の半径（キロメートル）

    dlat = (lat2 - lat1) * Math::PI / 180
    dlng = (lng2 - lng1) * Math::PI / 180

    a = Math.sin(dlat / 2) ** 2 +
        Math.cos(lat1 * Math::PI / 180) * Math.cos(lat2 * Math::PI / 180) * Math.sin(dlng / 2) ** 2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    radius * c # 距離（キロメートル）
  end

  def calculate_total_distance(checkpoints)
    total_distance = 0.0

    checkpoints.each_cons(2) do |prev_checkpoint, current_checkpoint|
      total_distance += haversine_distance(
        prev_checkpoint.lat, prev_checkpoint.lng,
        current_checkpoint.lat, current_checkpoint.lng
      )
    end

    total_distance.round(2)
  end
end