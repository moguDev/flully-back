class ChangeWalkIdToAllowNullInPosts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :posts, :walk_id, true
  end
end