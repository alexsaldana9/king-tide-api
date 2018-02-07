class ReadingsController < ApplicationController

  def get
    if is_invalid_float_param(:id)
      return input_error(:id)
    end

    reading = Reading.find_by_id(params[:id])

    if not reading
      return not_found
    end

    render :json => reading
  end

  def all
    render :json => Reading.all
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
