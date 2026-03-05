RSpec.describe Reservations::Rules::MaxDuration do
  describe ".call!" do
    subject(:call_rule) do
      described_class.call!(starts_at: starts_at, ends_at: ends_at)
    end

    let(:starts_at) { Time.zone.parse("2026-03-04 10:00") }

    context "when duration is less than 4 hours" do
      let(:ends_at) { starts_at + 3.hours }

      it "does not raise error" do
        expect { call_rule }.not_to raise_error
      end
    end

    context "when duration is exactly 4 hours" do
      let(:ends_at) { starts_at + 4.hours }

      it "does not raise error" do
        expect { call_rule }.not_to raise_error
      end
    end

    context "when duration exceeds 4 hours" do
      let(:ends_at) { starts_at + 5.hours }

      it "raises BusinessRuleError" do
        expect { call_rule }.to raise_error(
          Reservations::Rules::BusinessRuleError,
          "Maximum duration is 4 hours"
        )
      end
    end
  end
end
