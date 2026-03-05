require "rails_helper"

RSpec.describe "Api::V1::Reservations", type: :request do
  let!(:room) do
    Room.create!(
      name: "Room A",
      capacity: 10,
      has_projector: true,
      has_video_conference: false,
      floor: 1,
    )
  end

  let!(:user) do
    User.create!(
      name: "jesus",
      email: "jesus@test.com",
      department: "IT",
      max_capacity_allowed: 5,
      is_admin: false,
    )
  end

  describe "GET /api/v1/reservations" do
    before do
      Reservation.create!(
        room: room,
        user: user,
        starts_at: 1.hour.from_now,
        ends_at: 2.hours.from_now,
      )
    end

    it "returns reservations" do
      get "/api/v1/reservations"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json.size).to eq(1)
      expect(json.first["room_id"]).to eq(room.name)
      expect(json.first["user_id"]).to eq(user.name)
    end
  end

  describe "GET /api/v1/reservations/:id" do
    let!(:reservation) do
      Reservation.create!(
        room: room,
        user: user,
        starts_at: 1.hour.from_now,
        ends_at: 2.hours.from_now,
      )
    end

    it "returns a reservation" do
      get "/api/v1/reservations/#{reservation.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["id"]).to eq(reservation.id)
    end
  end

  describe "POST /api/v1/reservations" do
    let(:starts_at) { Time.zone.parse("2026-03-04 10:00") }
    let(:ends_at) { Time.zone.parse("2026-03-04 12:00") }

    let(:valid_params) do
      {
        room_id: room.id,
        user_id: user.id,
        starts_at: starts_at,
        ends_at: ends_at,
      }
    end
    it "creates reservation(s)" do
      post "/api/v1/reservations", params: valid_params

      puts Reservation.all.inspect
      puts response.body
    end
  end

  describe "PATCH /api/v1/reservations/:id/cancel" do
    let(:starts_at) { Time.zone.parse("2026-03-04 10:00") }
    let(:ends_at) { Time.zone.parse("2026-03-04 12:00") }

    let(:reservation) do
      Reservation.create!(
        room: room,
        user: user,
        starts_at: starts_at,
        ends_at: ends_at,
      )
    end

    it "cancels reservation" do
      patch "/api/v1/reservations/#{reservation.id}/cancel"
    end
  end
end
