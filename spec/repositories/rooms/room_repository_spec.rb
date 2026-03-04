require "rails_helper"

RSpec.describe Rooms::RoomRepository, type: :model do
  subject(:repo) { described_class.new }

  describe "#find_all" do
    it "returns all rooms" do
      room1 = Room.create!
      room2 = Room.create!

      expect(repo.find_all).to contain_exactly(room1, room2)
    end
  end

  describe "#find" do
    it "returns a room by id" do
      room = Room.create!
      expect(repo.find(room.id)).to eq(room)
    end
  end

  describe "#create" do
    it "creates a room" do
      expect {
        repo.create({})
      }.to change(Room, :count).by(1)
    end
  end
end