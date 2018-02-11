class ReadingsController < ApplicationController

  def get
    if is_invalid_float_param(:id)
      return input_error(:id)
    end

    id = params[:id]
    reading = cache_action "ReadingsController.get.#{id}" do
      Reading.includes(:photos).find_by_id(id)
    end

    if not reading
      return not_found
    end

    render partial: 'item', locals: {reading: reading}
  end

  def all
    readings = cache_action 'ReadingsController.all' do
      Reading.includes(:photos).all
    end
    render :collection, locals: {readings: readings}
  end

  def approved
    readings = cache_action 'ReadingsController.approved' do
      Reading.includes(:photos).approved
    end
    render :collection, locals: {readings: readings}
  end

  def pending
    result = cache_action 'ReadingsController.pending' do
      Reading.pending
    end
    render :json => result
  end

  private

  def reading_params
    params.permit(:id)
  end

end
