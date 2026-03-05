require "rails_helper"

RSpec.describe Rooms::Find do
  let(:repository) { instance_double(Rooms::RoomRepository) }
  let(:service) { described_class.new(repository: repository) }

  describe "#call" do
    let(:id) { 1 }

    it "delegates to repository.find" do
      expect(repository).to receive(:find).with(id)

      service.call(id)
    end

    it "returns the found room" do
      room = double("Room")
      allow(repository).to receive(:find).and_return(room)

      result = service.call(id)

      expect(result).to eq(room)
    end
  end
end