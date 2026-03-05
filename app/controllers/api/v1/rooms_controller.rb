class Api::V1::RoomsController < ApplicationController
  def index
    rooms = Rooms::FindAll.new.call
    render json: rooms, status: :ok
  end

  def show
    room = Rooms::Find.new.call(params[:id])
    render json: room, status: :ok
  end

  def create
    room = Rooms::Create.new.call(room_params)
    render json: room, status: :created
  end

  def availability
    rooms = Rooms::FindAll.new.call
    render json: rooms, status: :ok
  end

  private

  def room_params
    params.permit(:name, :capacity, :has_projector, :has_video_conference, :floor)
  end
end
