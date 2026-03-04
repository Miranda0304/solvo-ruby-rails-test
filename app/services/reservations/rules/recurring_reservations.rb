module Reservations
  module Rules
    class RecurringReservations
      def self.call!(params, repository: Reservations::ReservationRepository.new)
        new(params).call
      end

      def initialize(params, repository: Reservations::ReservationRepository.new)
        @params = params
        @repository = repository
      end

      def call
        ActiveRecord::Base.transaction do
          ocurrences = self.class.generate_occurrences(@params[:starts_at], @params[:ends_at], @params[:recurring], @params[:recurring_until])
          ocurrences.each do |occurrence|
            validate_rules!
            @repository.create(room: @params[:room], user: @params[:user], starts_at: occurrence[:starts])
          end
        end
      end

      private

      def recurring?
        @params[:recurring].present?
      end

      def duration
        @params[:ends_at] - @params[:starts_at]
      end

      def self.generate_occurrences(starts_at, ends_at, recurring, recurring_until)
        occurrences = []
        current = starts_at
        duration = ends_at - starts_at

        case recurring
        when "daily"
          while current.to_date <= recurring_until
            occurrences << {
              starts_at: current,
              ends_at: current + duration,
            }
            current = current + 1.day
          end
        when "weekly"
          while current.to_date <= recurring_until
            occurrences << {
              starts_at: current,
              ends_at: current + duration,
            }
            current = current + 1.week
          end
        end

        occurrences
      end

      def validate_rules!
        Reservations::Rules::NoOverlap.call!(room: @params[:room], starts_at: @params[:starts_at], ends_at: @params[:ends_at])
        Reservations::Rules::MaxDuration.call!(starts_at: @params[:starts_at], ends_at: @params[:ends_at])
        Reservations::Rules::BusinessHour.call!(starts_at: @params[:starts_at], ends_at: @params[:ends_at])
        Reservations::Rules::CapacityRestrictionByUser.call!(user: @params[:user], room: @params[:room])
        Reservations::Rules::ActiveReservation.call!(user: @params[:user])
      end
    end
  end
end
