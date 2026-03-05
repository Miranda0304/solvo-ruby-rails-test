module Reservations
  module Rules
    class RecurringReservations
      VALID_RECURRING_TYPES = %w[daily weekly].freeze

      def self.call!(params)
        new(params).call
      end

      def initialize(
        params,
        repo_reservation: Reservations::ReservationRepository.new,
        repo_user: Users::UserRepository.new,
        repo_room: Rooms::RoomRepository.new
      )
        @repo_reservation = repo_reservation

        @user = repo_user.find(params[:user_id])
        @room = repo_room.find(params[:room_id])

        @starts_at = parse_time!(params[:starts_at])
        @ends_at = parse_time!(params[:ends_at])

        @recurring = params[:recurring]
        @recurring_until = parse_time(params[:recurring_until])

        validate_recurring_params!
      end

      def call
        created = []

        ActiveRecord::Base.transaction do
          build_occurrences.each do |attrs|
            validate_rules!(attrs)
            created << @repo_reservation.create(attrs)
          end
        end

        created
      end

      private

      def parse_time!(value)
        Time.zone.parse(value.to_s) ||
          raise(Reservations::Rules::BusinessRuleError, "Invalid datetime format")
      end

      def parse_time(value)
        return nil if value.blank?
        Time.zone.parse(value.to_s)
      end

      def validate_recurring_params!
        return unless recurring?

        unless VALID_RECURRING_TYPES.include?(@recurring)
          raise Reservations::Rules::BusinessRuleError, "Invalid recurring type"
        end

        if @recurring_until.nil?
          raise Reservations::Rules::BusinessRuleError,
                "Recurring until date must be provided"
        end

        if @recurring_until < @starts_at
          raise Reservations::Rules::BusinessRuleError,
                "Recurring until must be after start date"
        end
      end

      def recurring?
        @recurring.present?
      end

      def duration
        @ends_at - @starts_at
      end

      def build_occurrences
        return [base_attrs] unless recurring?

        recurrence_dates.map do |date|
          base_attrs.merge(
            starts_at: date,
            ends_at: date + duration,
          )
        end
      end

      def recurrence_dates
        result = []
        current = @starts_at

        while current <= @recurring_until
          result << current
          current = next_occurrence(current)
        end

        result
      end

      def next_occurrence(current)
        case @recurring
        when "daily"
          current + 1.day
        when "weekly"
          current + 1.week
        else
          raise Reservations::Rules::BusinessRuleError, "Invalid recurring type"
        end
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
