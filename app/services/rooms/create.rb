module Rooms
  class Create
    def initialize(repository: Rooms::RoomRepository.new)
      @repository = repository
    end

    def call(attrs)
      @repository.create(attrs)
    end
  end
end
