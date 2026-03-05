require "rails_helper"

RSpec.describe Reservations::Rules::AdvanceCancellation do
  describe ".call!" do
    subject(:call_rule) { described_class.call!(id: reservation_id) }

    let(:repository) { instance_double(Reservations::ReservationRepository) }
    let(:reservation) { instance_double(Reservation) }
    let(:reservation_id) { 42 }

    before do
      allow(Reservations::ReservationRepository).to receive(:new)
          .and_return(repository)

      allow(repository).to receive(:find)
          .with(reservation_id)
          .and_return(reservation)
    end

    context "when cancellation is allowed (more than 60 minutes before)" do
      before do
        allow(reservation).to receive(:starts_at)
            .and_return(2.hours.from_now)

        allow(repository).to receive(:cancel)
            .with(reservation)
      end

      it "cancels the reservation" do
        expect(repository).to receive(:cancel)
            .with(reservation)

        call_rule
      end

      it "returns the reservation" do
        allow(repository).to receive(:cancel)

        result = call_rule

        expect(result).to eq(reservation)
      end
    end

    context "when cancellation is less than 60 minutes before start" do
      before do
        allow(reservation).to receive(:starts_at)
            .and_return(30.minutes.from_now)
      end

      it "raises BusinessRuleError" do
        expect {
          call_rule
        }.to raise_error(
          Reservations::Rules::BusinessRuleError,
          "Can not cancel less than 60 minutes before the reservation starts"
        )
      end

      it "does not call repository.cancel" do
        expect(repository).not_to receive(:cancel)

        begin
          call_rule
        rescue Reservations::Rules::BusinessRuleError
        end
      end
    end
  end
end
