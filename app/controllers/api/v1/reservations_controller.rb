class Api::V1::ReservationsController < ApplicationController
  def create
    reservation = Reservations::Rules::RecurringReservations.call!(reservation_params)

    render json: reservation, status: :created
  rescue Reservations::Rules::BusinessRuleError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def reservation_params
    params.permit(:room_id, :user_id, :starts_at, :ends_at, :recurring, :recurring_until)
  end
end
