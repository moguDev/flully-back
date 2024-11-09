class CreateThreadCommentLocationContents < ActiveRecord::Migration[7.1]
  def change
    create_table :thread_comment_location_contents do |t|
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
