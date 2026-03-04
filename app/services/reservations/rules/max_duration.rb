module Reservations
  module Rules
    class MaxDuration
      MAX_DURATION = 4.hours

      def self.call!(starts_at:, ends_at:)
        raise Reservations::Rules::BusinessRuleError, "Maximum duration is 4 hours" if ends_at - starts_at > MAX_DURATION
      end
    end
  end
end
