require "rails_helper"

RSpec.describe "Api::V1::Rooms", type: :request do
  describe "GET /api/v1/rooms" do
    it "returns rooms" do
      Room.create!(name: "Room A", capacity: 10)

      get "/api/v1/rooms"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/rooms" do
    it "creates a room" do
      expect {
        post "/api/v1/rooms", params: {
                                name: "Room B",
                                capacity: 8,
                              }
      }.to change(Room, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end
end
