class User < ApplicationRecord
  has_many :reservations
  validates :max_capacity_allowed, presence: true
end
