module Reservations
  class ReservationRepository
    def initialize(model: Reservation)
      @model = model
    end

    def find_all
      @model.includes(:room, :user)
    end

    def find(id)
      @model.find(id)
    end

    def create(attrs)
      @model.create!(attrs)
    end

    def cancel(reservation)
      reservation.update!(cancelled_at: Time.current)
    end
  end
end
