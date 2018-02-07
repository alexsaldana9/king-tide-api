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
    render :json => Reading.existent
  end

  def approved
    render :json => Reading.approved
  end

  def pending
    render :json => Reading.pending
  end

  private

  def reading_params
    params.permit(:id)
  end

end
