require "rails_helper"

RSpec.describe Users::Create do
  let(:repository) { instance_double(Users::UserRepository) }
  let(:service) { described_class.new(repository: repository) }

  let(:attrs) { { name: "Jesus", email: "jesus@test.com" } }

  describe "#call" do
    it "delegates creation to the repository" do
      expect(repository).to receive(:create).with(attrs)

      service.call(attrs)
    end

    it "returns the created user" do
      user = double("User")

      allow(repository).to receive(:create).and_return(user)

      result = service.call(attrs)

      expect(result).to eq(user)
    end
  end
end
