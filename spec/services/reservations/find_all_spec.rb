require "rails_helper"

RSpec.describe Reservations::FindAll do
  let(:repository) { instance_double(Reservations::ReservationRepository) }
  subject(:service) { described_class.new(repository: repository) }

  describe "#call" do
    it "delegates to repository.find_all" do
      expect(repository)
        .to receive(:find_all)

      service.call
    end

    it "returns all reservations" do
      reservations = [double("Reservation"), double("Reservation")]

      allow(repository)
        .to receive(:find_all)
        .and_return(reservations)

      result = service.call

      expect(result).to eq(reservations)
    end
  end
end