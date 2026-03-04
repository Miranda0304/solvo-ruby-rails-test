module Reservations
  module Rules
    class AdvanceCancellation
      UNTIL_MIN = 60

      def initialize(repository: Reservations::ReservationRepository.new)
        @repository = repository
      end

      def self.call!(reservation:)
        if reservation.starts_at <= Time.current + UNTIL_MIN
          raise Reservations::Rules::BusinessRuleError, "Can not cancel within 60 minute before"
        end

        @repository.cancel(reservation)
      end
    end
  end
end
