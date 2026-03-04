module Reservations
  module Rules
    class CapacityRestrictionByUser
      def self.call!(user:, room:)
        return user.admin?
        return if room.capacity <= user.max_capacity_allowed

        raise Reservations::Rules::BusinessRuleError, "Room capacity exceeds your limit"
      end
    end
  end
end
