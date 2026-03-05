require "rails_helper"

RSpec.describe Users::Find do
  let(:repository) { instance_double(Users::UserRepository) }
  let(:service) { described_class.new(repository: repository) }

  describe "#call" do
    let(:id) { 1 }

    it "delegates to repository.find with id" do
      expect(repository).to receive(:find).with(id)

      service.call(id)
    end

    it "returns the found user" do
      user = double("User")

      allow(repository).to receive(:find).and_return(user)

      result = service.call(id)

      expect(result).to eq(user)
    end
  end
end
