module Reservations
  module Rules
    class RecurringReservations
      def self.call!(params)
        new(params).call
      end

      def initialize(params,
                     repo_reservation: Reservations::ReservationRepository.new,
                     repo_user: Users::UserRepository.new,
                     repo_room: Rooms::RoomRepository.new)
        @user = repo_user.find(params[:user_id])
        @room = repo_room.find(params[:room_id])
        @repo_reservation = repo_reservation
        @starts_at = Time.zone.parse(params[:starts_at])
        @ends_at = Time.zone.parse(params[:ends_at])
        @recurring = params[:recurring]
        @recurring_until = parse_recurring_until(params[:recurring_until])
      end

      def parse_recurring_until(recurring_until)
        recurring_until && Time.zone.parse(recurring_until)
      end

      def call
        created = []
        ActiveRecord::Base.transaction do
          build_occurrences.each do |attrs|
            validate_rules!(attrs)
            created << @repo_reservation.create(attrs)
          end
          created
        end
      end

      private

      def recurring?
        @recurring.present?
      end

      def duration
        @ends_at - @starts_at
      end

      def build_occurrences
        return [base_attrs] unless recurring?

        dates.map do |date|
          base_attrs.merge(starts_at: date,
                           ends_at: date + duration)
        end
      end

      def dates
        result = []
        current = @starts_at

        while current <= @recurring_until
          result << current

          current = case @recurring
            when "daily"
              current + 1.day
            when "weekly"
              current + 1.week
            else
              raise Reservations::Rules::BusinessRuleError, "Invalid recurring type"
            end
        end

        result
      end

      def base_attrs
        {
          room: @room,
          user: @user,
          starts_at: @starts_at,
          ends_at: @ends_at,
        }
      end

      def validate_rules!(attrs)
        Reservations::Rules::NoOverlap.call!(
          room: @room,
          starts_at: attrs[:starts_at],
          ends_at: attrs[:ends_at],
        )

        Reservations::Rules::MaxDuration.call!(
          starts_at: attrs[:starts_at],
          ends_at: attrs[:ends_at],
        )

        Reservations::Rules::BusinessHours.call!(
          starts_at: attrs[:starts_at],
          ends_at: attrs[:ends_at],
        )

        Reservations::Rules::CapacityRestrictionByUser.call!(
          user: @user,
          room: @room,
        )

        Reservations::Rules::ActiveReservationLimit.call!(
          user: @user,
        )
      end
    end
  end
end
