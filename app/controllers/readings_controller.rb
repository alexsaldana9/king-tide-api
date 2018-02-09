class ReadingsController < ApplicationController

  def get
    if is_invalid_float_param(:id)
      return input_error(:id)
    end

    id = params[:id]
    reading = cache_action "ReadingsController.get.#{id}" do
      Reading.find_by_id(id)
    end

    if not reading
      return not_found
    end

    render :json => reading
  end

  def all
    result = cache_action 'ReadingsController.all' do
      Reading.all
    end
    render :json => result
  end

  def approved
    result = cache_action 'ReadingsController.approved' do
      Reading.approved
    end
    render :json => result
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
