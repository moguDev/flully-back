class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :introduction, :text
    add_column :users, :location, :string
    add_column :users, :avatar, :string
    add_column :users, :twitter, :string
  end
end
