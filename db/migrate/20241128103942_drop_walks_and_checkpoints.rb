class DropWalksAndCheckpoints < ActiveRecord::Migration[6.1]
  def up
    drop_table :checkpoints
    drop_table :walks
  end

  def down
    create_table :walks do |t|
      t.bigint :user_id, null: false
      t.datetime :start_time
      t.datetime :finish_time
      t.timestamps
    end

    create_table :checkpoints do |t|
      t.bigint :walk_id, null: false
      t.float :lat
      t.float :lng
      t.timestamps
    end
  end
end