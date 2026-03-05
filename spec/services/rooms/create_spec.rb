require "rails_helper"

RSpec.describe Rooms::Create do
  let(:repository) { instance_double(Rooms::RoomRepository) }
  let(:service) { described_class.new(repository: repository) }

  let(:attrs) { { name: "Room A", capacity: 10 } }

  describe "#call" do
    it "delegates creation to repository" do
      expect(repository).to receive(:create).with(attrs)

      service.call(attrs)
    end

    it "returns the created room" do
      room = double("Room")
      allow(repository).to receive(:create).and_return(room)

      result = service.call(attrs)

      expect(result).to eq(room)
    end
  end
end