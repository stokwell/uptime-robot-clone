class Site < ApplicationRecord
  belongs_to :user

  scope :by_user, ->(user) { where(user: user) }
end
