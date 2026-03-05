RSpec.describe Reservations::Rules::CapacityRestrictionByUser do
  describe ".call!" do
    subject(:call_rule) { described_class.call!(user: user, room: room) }

    let(:user) { instance_double("User") }
    let(:room) { instance_double("Room") }

    context "when user is admin" do
      before do
        allow(user).to receive(:is_admin?).and_return(true)
      end

      it "does not raise error" do
        expect { call_rule }.not_to raise_error
      end
    end

    context "when room capacity is within user limit" do
      before do
        allow(user).to receive(:is_admin?).and_return(false)
        allow(user).to receive(:max_capacity_allowed).and_return(10)
        allow(room).to receive(:capacity).and_return(8)
      end

      it "does not raise error" do
        expect { call_rule }.not_to raise_error
      end
    end

    context "when room capacity exceeds user limit" do
      before do
        allow(user).to receive(:is_admin?).and_return(false)
        allow(user).to receive(:max_capacity_allowed).and_return(5)
        allow(room).to receive(:capacity).and_return(10)
      end

      it "raises BusinessRuleError" do
        expect { call_rule }.to raise_error(
          Reservations::Rules::BusinessRuleError,
          "Room capacity exceeds your limit"
        )
      end
    end
  end
end
