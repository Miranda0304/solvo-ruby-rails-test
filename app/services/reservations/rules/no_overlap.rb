module Reservations
  module Rules
    class NoOverlap
      def self.call!(room:, starts_at:, ends_at:)
        conflict = room.reservations.where(cancelled_at: nil).where("starts_at < ? AND ends_at > ?", ends_at, starts_at)

        raise Reservations::Rules::BusinessRuleError, "Room already reserved for this period"
      end
    end
  end
end
