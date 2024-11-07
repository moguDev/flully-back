class ChangeSpeciesTypeInBoardsAndAddBreed < ActiveRecord::Migration[6.1]
  def change
    # species を integer 型に変更
    change_column :boards, :species, :integer, using: 'species::integer'

    # breed カラムを追加
    add_column :boards, :breed, :string
  end
end