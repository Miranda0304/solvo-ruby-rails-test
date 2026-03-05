require "rails_helper"

RSpec.describe Reservations::Rules::BusinessHours do
  describe ".call!" do
    subject(:call_rule) { described_class.call!(starts_at: starts_at, ends_at: ends_at) }

    context "when reservation is valid" do
      let(:starts_at) { Time.zone.parse("2026-03-04 10:00") } # Wednesday
      let(:ends_at) { Time.zone.parse("2026-03-04 11:00") }

      it "does not raise error" do
        expect { call_rule }.not_to raise_error
      end
    end

    context "when reservation spans multiple days" do
      let(:starts_at) { Time.zone.parse("2026-03-04 17:00") }
      let(:ends_at) { Time.zone.parse("2026-03-05 10:00") }

      it "raises BusinessRuleError" do
        expect { call_rule }.to raise_error(
          Reservations::Rules::BusinessRuleError,
          "Reservation must start and end on the same day"
        )
      end
    end

    context "when reservation is on weekend" do
      let(:starts_at) { Time.zone.parse("2026-03-07 10:00") } # Saturday
      let(:ends_at) { Time.zone.parse("2026-03-07 11:00") }

      it "raises BusinessRuleError" do
        expect { call_rule }.to raise_error(
          Reservations::Rules::BusinessRuleError,
          "Outside business days"
        )
      end
    end

    context "when reservation starts before business hours" do
      let(:starts_at) { Time.zone.parse("2026-03-04 08:00") }
      let(:ends_at) { Time.zone.parse("2026-03-04 09:30") }

      it "raises BusinessRuleError" do
        expect { call_rule }.to raise_error(
          Reservations::Rules::BusinessRuleError,
          "Outside business hours"
        )
      end
    end

    context "when reservation ends after business hours" do
      let(:starts_at) { Time.zone.parse("2026-03-04 17:30") }
      let(:ends_at) { Time.zone.parse("2026-03-04 19:00") }

      it "raises BusinessRuleError" do
        expect { call_rule }.to raise_error(
          Reservations::Rules::BusinessRuleError,
          "Outside business hours"
        )
      end
    end
  end
end
