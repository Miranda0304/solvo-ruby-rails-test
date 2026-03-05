require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users" do
    it "returns users" do
      User.create!(
        name: "jesus",
        email: "jesus@test.com",
        department: "HR",
        max_capacity_allowed: 4,
      )

      get "/api/v1/users"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/users" do
    it "creates a user" do
      expect {
        post "/api/v1/users", params: {
                           name: "jesus",
                           email: "jesus@test.com",
                           department: "Finance",
                           max_capacity_allowed: 6,
                         }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end
end
