class CreateWalks < ActiveRecord::Migration[7.1]
  def change
    create_table :walks do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :finish_time

      t.timestamps
    end
  end
end
