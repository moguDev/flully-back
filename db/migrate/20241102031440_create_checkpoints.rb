class CreateCheckpoints < ActiveRecord::Migration[7.1]
  def change
    create_table :checkpoints do |t|
      t.references :walk, null: false, foreign_key: true
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
