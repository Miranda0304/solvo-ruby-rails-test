RSpec.describe Reservations::Rules::NoOverlap, type: :model do
  describe ".call!" do
    subject(:call_rule) do
      described_class.call!(
        room: room,
        starts_at: new_start,
        ends_at: new_end,
      )
    end

    let(:room) { create(:room) }
    let(:new_start) { Time.zone.parse("2026-03-04 10:00") }
    let(:new_end) { Time.zone.parse("2026-03-04 12:00") }

    context "when there are no reservations" do
      it "does not raise error" do
        expect { call_rule }.not_to raise_error
      end
    end

    context "when there is a non-overlapping reservation" do
      before do
        create(:reservation,
               room: room,
               starts_at: new_end + 1.hour,
               ends_at: new_end + 2.hours,
               cancelled_at: nil)
      end

      it "does not raise error" do
        expect { call_rule }.not_to raise_error
      end
    end

    context "when there is an overlapping reservation" do
      before do
        create(:reservation,
               room: room,
               starts_at: new_start + 30.minutes,
               ends_at: new_end + 1.hour,
               cancelled_at: nil)
      end

      it "raises BusinessRuleError" do
        expect { call_rule }.to raise_error(
          Reservations::Rules::BusinessRuleError,
          "Room already reserved for this period"
        )
      end
    end

    context "when overlapping reservation is cancelled" do
      before do
        create(:reservation,
               room: room,
               starts_at: new_start + 30.minutes,
               ends_at: new_end + 1.hour,
               cancelled_at: Time.current)
      end

      it "does not raise error" do
        expect { call_rule }.not_to raise_error
      end
    end
  end
end
