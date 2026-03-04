module Users
  class UserRepository
    def initialize(model: User)
      @model = model
    end

    def find_all
      @model.all
    end

    def find(id)
      @model.find(id)
    end

    def create(attrs)
      @model.create!(attrs)
    end
  end
end
