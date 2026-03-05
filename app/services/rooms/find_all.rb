module Rooms
  class FindAll
    def initialize(repository: Rooms::RoomRepository.new, filters: {})
      @repository = repository
      @filters = filters
    end

    def call
      scope = @repository.find_all
      scope = filter_by_rooms_available(scope, @filters[:available]) if @filters[:available].present?
      scope
    end

    private

    # date format: YYYY-MM-DD
    def filter_by_rooms_available(scope, date_string)
      date = Date.parse(date_string)

      scope
        .left_joins(:reservations)
        .where(
          reservations: { id: nil },
        )
        .or(
          scope.where.not(
            id: Reservation
              .where(cancelled_at: nil)
              .where("DATE(starts_at) <= ? AND DATE(ends_at) >= ?", date, date)
              .select(:room_id),
          )
        )
    end
  end
end
