require "rails_helper"

RSpec.describe Reservations::Find do
  let(:repository) { instance_double(Reservations::ReservationRepository) }
  subject(:service) { described_class.new(repository: repository) }

  describe "#call" do
    let(:id) { 42 }

    it "delegates to repository.find with id" do
      expect(repository)
        .to receive(:find)
        .with(id)

      service.call(id)
    end

    it "returns the found reservation" do
      reservation = double("Reservation")

      allow(repository)
        .to receive(:find)
        .and_return(reservation)

      result = service.call(id)

      expect(result).to eq(reservation)
    end
  end
end