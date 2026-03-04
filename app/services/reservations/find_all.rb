module Reservations
  class FindAll
    def initialize(repository: Reservations::ReservationRepository.new)
      @repository = repository
    end

    def call
      @repository.find_all
    end
  end
end
