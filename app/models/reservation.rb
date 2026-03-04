class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  scope :active, -> { where(cancelled_at:   nil).where("ends_at > ?", Time.current) }
end
