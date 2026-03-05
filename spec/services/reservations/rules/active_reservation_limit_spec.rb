require "rails_helper"

RSpec.describe Reservations::Rules::ActiveReservationLimit do
  describe ".call!" do
    let(:user) { instance_double(User) }
    let(:reservations_association) { double("reservations_association") }
    let(:active_scope) { double("active_scope") }

    before do
      allow(user).to receive(:reservations).and_return(reservations_association)
      allow(reservations_association).to receive(:active).and_return(active_scope)
    end

    context "when user is admin" do
      before do
        allow(user).to receive(:is_admin?).and_return(true)
      end

      it "does not raise error" do
        expect {
          described_class.call!(user: user)
        }.not_to raise_error
      end
    end

    context "when user is not admin" do
      before do
        allow(user).to receive(:is_admin?).and_return(false)
      end

      context "and active reservations are below limit" do
        before do
          allow(active_scope).to receive(:count).and_return(2)
        end

        it "does not raise error" do
          expect {
            described_class.call!(user: user)
          }.not_to raise_error
        end
      end

      context "and active reservations reach the limit" do
        before do
          allow(active_scope).to receive(:count).and_return(3)
        end

        it "raises BusinessRuleError" do
          expect {
            described_class.call!(user: user)
          }.to raise_error(
            Reservations::Rules::BusinessRuleError,
            "You already have 3 active reservations"
          )
        end
      end
    end
  end
end
