class ReadingsController < ApplicationController

  def getall
    # @page = params[:page] ? params[:page].to_i : 1
    @message = 'All readings'
    @readings = Reading.all.each
    # @count = @users.count
    # render :getall, status: :ok

    render :json => @readings
  end

  def user_params
    params.permit(:depth, :units_depth, :salinity, :units_salinity, :description)
  end

end
