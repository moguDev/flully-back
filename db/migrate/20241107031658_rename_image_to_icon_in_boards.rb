class RenameImageToIconInBoards < ActiveRecord::Migration[6.1]
  def change
    rename_column :boards, :image, :icon
  end
end