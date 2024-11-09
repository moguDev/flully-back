class CreateThreadCommentImageContents < ActiveRecord::Migration[7.1]
  def change
    create_table :thread_comment_image_contents do |t|
      t.string :url

      t.timestamps
    end
  end
end
