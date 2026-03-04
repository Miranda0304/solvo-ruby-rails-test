module Users
  class RoomRepository
    def initialize(model: Room)
      @model = model
    end

    def find(id)
      @model.find(id)
    end

    def create(attrs)
      @model.create!(attrs)
    end
  end
end
