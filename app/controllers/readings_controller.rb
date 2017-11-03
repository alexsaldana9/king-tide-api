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
    @reading = Reading.new(reading_params)
    if @reading.save
      render :json => @reading
    else
      @error = 'Error saving reading'
      render :json => @error, status: 400
    end
  end

  def update
    # Need to allow this method only for admin, add another field to get the name of person that edited
    @reading = Reading.find_by(id: params[:id])
    if @reading.update(reading_params)
      render :json => @reading
    else
      @error = 'Error updating the reading'
      render :json => @error, status: 400
    end
  end

  def delete
    # Need to allow this method only for admin, add another field to get the name of person that deleted
    #Or maybe this method is not necessary, this can complicate the data management
    if @reading = Reading.find_by(id: params[:id])
      @reading.delete
      @message = 'Record deleted'
      render :json => @message
    else
      @error = 'Error deleting the reading'
      render :json => @error
    end


  end

  def status
    @message = 'Status OK'
    render :json => @message
  end

  def reading_params
    params.permit(:depth, :units_depth, :salinity, :units_salinity, :description)
  end


end
