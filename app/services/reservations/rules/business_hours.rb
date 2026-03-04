module Reservations
  module Rules
    class BusinessHours
      START_HOUR = 9
      END_HOUR = 18

      def self.call!(starts_at:, ends_at:)
        validate_same_day!(starts_at, ends_at)
        validate_business_day!(starts_at)
        validate_business_hours!(starts_at, ends_at)
      end

      def self.validate_same_day!(starts_at, ends_at)
        unless starts_at.to_date == ends_at.to_date
          raise Reservations::Rules::BusinessRuleError, "Reservation must start and end on the same day"
        end
      end

      def self.validate_business_day!(time)
        if time.saturday? || time.sunday?
          raise Reservations::Rules::BusinessRuleError, "Outside business days"
        end
      end

      def self.validate_business_hours!(starts_at, ends_at)
        business_start = starts_at.change(hour: START_HOUR, min: 0, sec: 0)
        business_end = starts_at.change(hour: END_HOUR, min: 0, sec: 0)

        unless starts_at >= business_start && ends_at <= business_end
          raise Reservations::Rules::BusinessRuleError, "Outside business hours"
        end
      end
    end
  end
end
