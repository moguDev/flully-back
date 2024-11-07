class CreateBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :boards do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :category
      t.string :species
      t.string :name
      t.string :image
      t.integer :age
      t.datetime :date
      t.float :lat
      t.float :lng
      t.boolean :is_location_public
      t.text :body
      t.text :feature
      t.integer :status

      t.timestamps
    end
  end
end
