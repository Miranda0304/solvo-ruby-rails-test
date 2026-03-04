module Reservations
  class Find
    def initialize(repository: Reservations::ReservationRepository.new)
      @repository = repository
    end

    def call(id)
      @repository.find(id)
    end
  end
end
