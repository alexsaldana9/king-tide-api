class ReadingsController < ApplicationController

  def getall
    readings = Reading.all.each
    render :json => readings
  end

  def get
    reading = Reading.find_by(id: params[:id])
    render :json => reading
  end

  def create
    #TODO: move this to the ApplicationController
    #TODO: remove the users controller/model/etc

    if request_is_not_authorized
      return unauthorized_request
    end

    reading = Reading.new(reading_params)
    reading.save
    render :json => reading
  end

  def update
    if request_is_not_authorized
      return unauthorized_request
    end

    reading = Reading.find_by(id: params[:id])
    reading.update(reading_params)
    render :json => reading
  end

  def delete
    # Need to allow this method only for admin, add another field to get the name of person that deleted
    #Or maybe this method is not necessary, this can complicate the data management

    if request_is_not_authorized
      return unauthorized_request
    end

    reading = Reading.find_by(id: params[:id])
    reading.destroy
    render :json => {status: 'Record deleted'}

  end

  def reading_params
    params.permit(:depth, :units_depth, :salinity, :units_salinity, :description)
  end

end
