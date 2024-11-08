class AddLocationToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :location, :string
  end
end
