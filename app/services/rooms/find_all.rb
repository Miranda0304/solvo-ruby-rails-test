module Rooms
  class FindAll
    def initialize(repository: Rooms::RoomRepository.new)
      @repository = repository
    end

    def call
      @repository.find_all
    end
  end
end
