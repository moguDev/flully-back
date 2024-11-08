class CreateBoardImages < ActiveRecord::Migration[6.1]
  def change
    create_table :board_images do |t|
      t.references :board, null: false, foreign_key: true
      t.string :image, null: false

      t.timestamps
    end
  end
end