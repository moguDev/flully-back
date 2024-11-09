class CreateBoardComments < ActiveRecord::Migration[7.1]
  def change
    create_table :board_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.string :content_type
      t.integer :content_id

      t.timestamps
    end
  end
end
