module Users
  class UserRepository
    def initialize(model: User)
      @model = model
    end

    def find_all
      User.all
    end

    def find(id)
      @model.find(id)
    end

    def create(attrs)
      @model.create!(attrs)
    end
  end
end
