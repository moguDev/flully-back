class Api::V1::TimelineController < ApplicationController
  def index
    posts = Post.includes(:user).order(created_at: :asc).limit(100)
                .map do |post|
                  {
                    type: "post",
                    content: PostSerializer.new(post).as_json
                  }
                end

    boards = Board.includes(:user).order(created_at: :asc).limit(100)
                  .map do |board|
                    {
                      type: "board",
                      content: BoardSerializer.new(board).as_json
                    }
                  end

    # 結合し、created_atでソートして100件取得
    timeline = (posts + boards).sort_by { |item| item[:content]["created_at"] }.reverse.take(100)

    render json: timeline
  end
end