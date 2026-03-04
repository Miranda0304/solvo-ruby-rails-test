module Users
  class Find
    def initialize(repository: Users::UserRepository.new)
      @repository = repository
    end

    def call(id)
      @repository.find(id)
    end
  end
end
