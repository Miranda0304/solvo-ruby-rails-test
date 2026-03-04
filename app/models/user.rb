class User < ApplicationRecord
  has_many :reservations

  enum role: { user: 0, admin: 1 }

  validates :max_capacity_allowed, presence: true
end
