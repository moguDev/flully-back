class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :category
      t.text :body
      t.boolean :checked
      t.string :url

      t.timestamps
    end
  end
end
