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
    readings = Reading.where(deleted: false, approved: true)
    render :json => readings
  end

  def pending
    readings = Reading.where(deleted: false, approved: false)
    render :json => readings
  end

  private

  def reading_params
    params.permit(:id)
  end

end
