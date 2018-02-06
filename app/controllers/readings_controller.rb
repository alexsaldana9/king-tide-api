class ReadingsController < ApplicationController

  def get
    reading = Reading.find_by(id: params[:id])
    render :json => reading
  end

  def all
    readings = Reading.all.each
    render :json => readings
  end

  def approved
    readings = Reading.where(deleted: false)
                   .where(approved: true)
    render :json => readings
  end

  def pending
    reading = Reading.where(deleted: false)
                  .where(approved: false)
    render :json => reading
  end

  private

  def reading_params
    params.permit(:id)
  end

end
