class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :walk, null: false, foreign_key: true
      t.string :image
      t.text :body
      t.float :lat
      t.float :lng
      t.boolean :is_anonymous

      t.timestamps
    end
  end
end
