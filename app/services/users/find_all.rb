module Users
  class FindAll
    def initialize(repository: Users::UserRepository.new)
      @repository = repository
    end

    def call
      @repository.find_all
    end
  end
end
