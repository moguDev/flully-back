class UserSetting < ApplicationRecord
  belongs_to :user
  validates :is_location_public, inclusion: { in: [true, false] }
  validates :is_mail_public, inclusion: { in: [true, false] }
end
