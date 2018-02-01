class Site < ApplicationRecord
  belongs_to :user
  has_many :pings

  scope :by_user, ->(user) { where(user: user) }


end
