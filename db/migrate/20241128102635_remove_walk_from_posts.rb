class RemoveWalkFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_reference :posts, :walk, foreign_key: true
  end
end