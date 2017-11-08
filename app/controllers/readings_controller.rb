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
    #TODO: secure all the other api methods
    #TODO: remove the users controller/model/etc

    if request_is_authorized == true
      reading = Reading.new(reading_params)
      reading.save
      render :json => reading
    else
      unauthorized_request
    end

  end

  def update

    if request_is_authorized == true
      reading = Reading.find_by(id: params[:id])
      reading.update(reading_params)
      render :json => reading
    else
      unauthorized_request
    end

  end

  def delete
    # Need to allow this method only for admin, add another field to get the name of person that deleted
    #Or maybe this method is not necessary, this can complicate the data management

    if request_is_authorized == true
      reading = Reading.find_by(id: params[:id])
      reading.destroy
      render :json => {status: 'Record deleted'}
    else
      unauthorized_request
    end

  end

  def reading_params
    params.permit(:depth, :units_depth, :salinity, :units_salinity, :description)
  end

end
