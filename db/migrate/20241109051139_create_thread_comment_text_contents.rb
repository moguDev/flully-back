class CreateThreadCommentTextContents < ActiveRecord::Migration[7.1]
  def change
    create_table :thread_comment_text_contents do |t|
      t.text :body

      t.timestamps
    end
  end
end
