module Reservations
  module Rules
    class AdvanceCancellation
      UNTIL_MIN = 60.minutes

      def self.call!(id:)
        new.call!(id: id)
      end

      def initialize(repository: Reservations::ReservationRepository.new)
        @repository = repository
      end

      def call!(id:)
        reservation = @repository.find(id)
        validate_rules!(reservation)
        @repository.cancel(reservation)
        reservation
      end

      def validate_rules!(reservation)
        if reservation.starts_at <= Time.current + UNTIL_MIN
          raise Reservations::Rules::BusinessRuleError, "Can not cancel less than 60 minutes before the reservation starts"
        end
      end
    end
  end
end
