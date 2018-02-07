class ReadingsController < ApplicationController

  def get
    if is_invalid_float_param(:id)
      return input_error(:id)
    end

    reading = Reading.existent.find_by_id(params[:id])

    if not reading
      return not_found
    end

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
