require "rails_helper"

RSpec.describe Users::UserRepository, type: :model do
  subject(:repo) { described_class.new }

  describe "#find_all" do
    it "returns all users" do
      user1 = User.create!(max_capacity_allowed: 3)
      user2 = User.create!(max_capacity_allowed: 5)

      expect(repo.find_all).to contain_exactly(user1, user2)
    end
  end

  describe "#find" do
    it "returns user by id" do
      user = User.create!(max_capacity_allowed: 4)
      expect(repo.find(user.id)).to eq(user)
    end
  end

  describe "#create" do
    it "creates a user" do
      expect {
        repo.create(max_capacity_allowed: 10)
      }.to change(User, :count).by(1)
    end
  end
end