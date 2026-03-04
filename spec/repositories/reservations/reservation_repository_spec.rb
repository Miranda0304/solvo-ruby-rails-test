require "rails_helper"

RSpec.describe Reservations::ReservationRepository, type: :model do
  subject(:repo) { described_class.new }

  let(:room) { Room.create! }
  let(:user) { User.create!(max_capacity_allowed: 5) }

  describe "#find_all" do
    it "includes room and user associations" do
      reservation = Reservation.create!(
        room: room,
        user: user,
        starts_at: 1.hour.from_now,
        ends_at: 2.hours.from_now,
      )

      result = repo.find_all.first

      expect(result.association(:room)).to be_loaded
      expect(result.association(:user)).to be_loaded
      expect(result).to eq(reservation)
    end
  end

  describe "#find" do
    it "returns the reservation by id" do
      reservation = Reservation.create!(
        room: room,
        user: user,
        starts_at: 1.hour.from_now,
        ends_at: 2.hours.from_now,
      )

      expect(repo.find(reservation.id)).to eq(reservation)
    end
  end

  describe "#create" do
    it "creates a reservation" do
      expect {
        repo.create(
          room: room,
          user: user,
          starts_at: 1.hour.from_now,
          ends_at: 2.hours.from_now,
        )
      }.to change(Reservation, :count).by(1)
    end
  end

  describe "#cancel" do
    it "sets cancelled_at timestamp" do
      reservation = Reservation.create!(
        room: room,
        user: user,
        starts_at: 1.hour.from_now,
        ends_at: 2.hours.from_now,
      )

      repo.cancel(reservation)

      expect(reservation.reload.cancelled_at).not_to be_nil
    end
  end
end
