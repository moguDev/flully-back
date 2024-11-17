class CreateUserSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :is_mail_public
      t.boolean :is_location_public

      t.timestamps
    end
  end
end
