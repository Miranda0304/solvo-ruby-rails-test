module Users
  class Create
    def initialize(repository: Users::UserRepository.new)
      @repository = repository
    end

    def call(attrs)
      @repository.create(attrs)
    end
  end
end
