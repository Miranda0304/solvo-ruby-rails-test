class Api::V1::ReservationsController < ApplicationController
  def create
    reservations = Reservations::Rules::RecurringReservations.call!(params_reservation)

    render json: serialize_collection(reservations), status: :created
  rescue Reservations::Rules::BusinessRuleError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  # def params_reservation
  #   {
  #     room: Room.find(params[:room_id]),
  #     user: User.find(params[:user_id]),
  #     starts_at: Time.zone.parse(params[:starts_at]),
  #     ends_at: Time.zone.parse(params[:ends_at]),
  #     recurring: params[:recurring],
  #     recurring_until: params[:recurring_until] && Time.zone.parse(params[:recurring_until]),
  #   }
  # end

  def params_reservation
    params.permit(:room_id, :user_id, :starts_at, :ends_at, :recurring, :recurring_until)
  end

  def serialize(reservation)
    {
      id: reservation.id,
      room_id: reservation.room_id,
      user_id: reservation.user_id,
      starts_at: reservation.starts_at,
      ends_at: reservation.ends_at,
    }
  end

  def serialize_collection(reservations)
    reservations.map { |r| serialize(r) }
  end
end
