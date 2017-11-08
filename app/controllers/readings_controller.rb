class ReadingsController < ApplicationController

  def getall
    @readings = Reading.all.each
    render :json => @readings
  end

  def get
    @reading = Reading.find_by(id: params[:id])
    render :json => @reading
  end

  def create
    # apiKey = request.headers["apiKey"]
    # puts "value of api key #{apiKey}"

    #TODO: move this to the ApplicationController
    #TODO: secure all the other api methods

    if request_is_authorized == true
      @reading = Reading.new(reading_params)
      @reading.save
      render :json => @reading
    else
      render :json => {error: 'Unauthorized'}, status: 401
    end


    # if Secretkey.where(key: apiKey).empty?
    #   @error = 'Error saving reading'
    #   render :json => @error, status: 401
    # else
    #   @reading = Reading.new(reading_params)
    #   @reading.save
    #   render :json => @reading
    # end
  end

  def update
    # Need to allow this method only for admin, add another field to get the name of person that edited
    apiKey = request.headers["apiKey"]
    if Secretkey.where(key: apiKey).empty?
      @error = 'Error updating the reading'
      render :json => @error.to_json, status: 400
    else
      @reading = Reading.find_by(id: params[:id])
      @reading.update(reading_params)
      render :json => @reading.to_json
    end


    # @reading = Reading.find_by(id: params[:id])
    # if @reading.update(reading_params)
    #   render :json => @reading
    # else
    #   @error = 'Error updating the reading'
    #   render :json => @error, status: 400
    # end
  end

  def delete
    # Need to allow this method only for admin, add another field to get the name of person that deleted
    #Or maybe this method is not necessary, this can complicate the data management

    apiKey = request.headers["apiKey"]
    if Secretkey.where(key: apiKey).empty?
      @error = 'Error deleting the reading'
      render :json => @error.to_json
    else
      @reading = Reading.find_by(id: params[:id])
      @reading.destroy
      @message = 'Record deleted'
      render :json => @message.to_json
    end


    # if @reading = Reading.find_by(id: params[:id])
    #   @reading.delete
    #   @message = 'Record deleted'
    #   render :json => @message
    # else
    #   @error = 'Error deleting the reading'
    #   render :json => @error
    # end


  end

  def reading_params
    params.permit(:depth, :units_depth, :salinity, :units_salinity, :description)
  end

end
