require "rails_helper"

RSpec.describe Reservation, type: :model do
  describe "associations" do
    it { should belong_to(:room) }
    it { should belong_to(:user) }
  end

  describe ".active scope" do
    let(:room) { Room.create! }
    let(:user) { User.create!(max_capacity_allowed: 5) }

    let!(:active_reservation) do
      Reservation.create!(
        room: room,
        user: user,
        starts_at: 1.hour.ago,
        ends_at: 1.hour.from_now,
        cancelled_at: nil
      )
    end

    let!(:cancelled_reservation) do
      Reservation.create!(
        room: room,
        user: user,
        starts_at: 1.hour.ago,
        ends_at: 1.hour.from_now,
        cancelled_at: Time.current
      )
    end

    let!(:past_reservation) do
      Reservation.create!(
        room: room,
        user: user,
        starts_at: 2.hours.ago,
        ends_at: 1.hour.ago,
        cancelled_at: nil
      )
    end

    it "returns only non-cancelled and future-ending reservations" do
      expect(Reservation.active).to contain_exactly(active_reservation)
    end
  end
end