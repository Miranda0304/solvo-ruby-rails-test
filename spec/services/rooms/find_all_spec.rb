require "rails_helper"

RSpec.describe Rooms::FindAll do
  let(:repository) { instance_double(Rooms::RoomRepository) }
  let(:base_scope) { instance_double(ActiveRecord::Relation) }
  let(:where_chain) { instance_double(ActiveRecord::QueryMethods::WhereChain) }

  describe "#call" do
    context "without filters" do
      subject(:service) do
        described_class.new(repository: repository)
      end

      it "returns all rooms from repository" do
        expect(repository).to receive(:find_all)
            .and_return(base_scope)

        result = service.call

        expect(result).to eq(base_scope)
      end
    end

    context "with available filter" do
      let(:date_string) { "2026-03-10" }

      subject(:service) do
        described_class.new(
          repository: repository,
          filters: { available: date_string },
        )
      end

      before do
        allow(repository).to receive(:find_all).and_return(base_scope)

        # left_joins
        allow(base_scope).to receive(:left_joins)
            .with(:reservations)
            .and_return(base_scope)

        # where(reservations: { id: nil })
        allow(base_scope).to receive(:where)
            .with(reservations: { id: nil })
            .and_return(base_scope)

        # scope.where (without args) → returns WhereChain
        allow(base_scope).to receive(:where)
            .with(no_args)
            .and_return(where_chain)

        # where_chain.not(...)
        allow(where_chain).to receive(:not)
            .and_return(base_scope)

        # or(...)
        allow(base_scope).to receive(:or)
            .and_return(base_scope)
      end

      it "applies availability filter and returns filtered scope" do
        result = service.call

        expect(result).to eq(base_scope)
      end
    end
  end
end
