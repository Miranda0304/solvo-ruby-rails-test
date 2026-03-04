module Rooms
  class Find
    def initialize(repository: Rooms::RoomRepository.new)
      @repository = repository
    end

    def call(id)
      @repository.find(id)
    end
  end
end
