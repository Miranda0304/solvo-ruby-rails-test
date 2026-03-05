RSpec.describe Reservations::Rules::BusinessHours do
  describe ".call!" do
    it "raises BusinessRuleError when outside business days" do
      saturday = Time.zone.parse("2026-03-07 10:00") # Saturday

      expect {
        described_class.call!(
          starts_at: saturday,
          ends_at: saturday + 1.hour,
        )
      }.to raise_error(Reservations::Rules::BusinessRuleError, "Outside business days")
    end
  end
end
