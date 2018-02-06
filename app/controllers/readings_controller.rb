class ReadingsController < ApplicationController

  def get_all
    readings = Reading.all.each
    render :json => readings
  end

  def get_all_approved
    readings = Reading.where(deleted: false)
                   .where(approved: true)
    render :json => readings
  end

  def get
    reading = Reading.find_by(id: params[:id])
    render :json => reading
  end

  def get_pending
    reading = Reading.where(deleted: false)
                  .where(approved: false)
    render :json => reading
  end

  private

  def reading_params
    params.permit(:id)
  end

end
