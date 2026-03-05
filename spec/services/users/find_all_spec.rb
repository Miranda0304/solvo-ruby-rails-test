require "rails_helper"

RSpec.describe Users::FindAll do
  let(:repository) { instance_double(Users::UserRepository) }
  let(:service) { described_class.new(repository: repository) }

  describe "#call" do
    it "delegates to repository.find_all" do
      expect(repository).to receive(:find_all)

      service.call
    end

    it "returns the collection of users" do
      users = [double("User"), double("User")]

      allow(repository).to receive(:find_all).and_return(users)

      result = service.call

      expect(result).to eq(users)
    end
  end
end
