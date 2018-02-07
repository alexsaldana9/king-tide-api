class ReadingsController < ApplicationController

  def get
    reading = Reading.find(params[:id])
    render :json => reading
  end

  def all
    readings = Reading.all.each
    render :json => readings
  end

  def approved
    readings = Reading.existent.where(approved: true)
    render :json => readings
  end

  def pending
    readings = Reading.existent.where(approved: false)
    render :json => readings
  end

  private

  def reading_params
    params.permit(:id)
  end

end
