module Reservations
  module Rules
    class ActiveReservationLimit
      LIMIT = 3
      def self.call!(user:)
        return if user.is_admin?
        return if user.reservations.active.count < LIMIT

        raise Reservations::Rules::BusinessRuleError, "You already have #{LIMIT} active reservations"
      end
    end
  end
end
