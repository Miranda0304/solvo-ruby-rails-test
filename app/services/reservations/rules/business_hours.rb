module Reservations
  module Rules
    class BusinessHours
      START_HOUR = 9
      END_HOUR = 18

      def self.call!(starts_at:, ends_at:)
        raise Reservations::Rules::BusinessRuleError, "Outside business days" if weekend?(starts_at)

        unless within_hours(starts_at, ends_at)
          raise Reservations::Rules::BusinessRuleError, "Outside business hours"
        end
      end

      def self.weekend?(time)
        time.saturday? || time.sunday?
      end

      def self.within_hours(starts_at, ends_at)
        starts_at.hour >= START_HOUR && ends_at.hour < END_HOUR
      end
    end
  end
end
