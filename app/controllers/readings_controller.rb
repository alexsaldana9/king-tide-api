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
    render_reading_collection :all
  end

  def approved
    render_reading_collection :approved
  end

  def pending
    render_reading_collection :pending
  end

  private

  def reading_params
    params.permit(:id)
  end

  def render_reading_collection(name)
    readings = cache_action "ReadingsController.collection.#{name}" do
      Reading.includes(:photos).send(name)
    end
    render :collection, locals: {readings: readings}
  end

end
