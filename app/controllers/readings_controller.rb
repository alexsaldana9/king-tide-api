class ReadingsController < ApplicationController

  def get_all
    readings = Reading.all.each
    render :json => readings
  end

  def get_all_approved
    readings = Reading.where(deleted: false)
                   .where(approved: true)
    render :json => readings
  end

  def get
    reading = Reading.find_by(id: params[:id])
    render :json => reading
  end

  def get_pending
    reading = Reading.where(approved: false)
                    .where(deleted: false)
    render :json => reading
  end

  def approve_reading
    
  end

  def create
    p "create; params=#{params}"

    if request_is_not_authorized
      return unauthorized_request
    end

    if is_invalid_float_param(:depth)
      return input_error(:depth)
    end

    if params[:salinity] != nil and is_invalid_float_param(:salinity)
      return input_error(:salinity)
    end

    if params[:salinity] != nil and is_invalid_string_param(:units_salinity)
      return input_error(:units_salinity)
    end

    if is_invalid_string_param(:units_depth)
      return input_error(:units_depth)
    end

    full_params = reading_params
    full_params[:approved] = false
    full_params[:deleted] = false
    reading = Reading.create(full_params)

    p "create; result=success; reading_id=#{reading.id}"

    render :json => reading
  end


  def delete
    # Need to allow this method only for admin, add another field to get the name of person that deleted
    #Or maybe this method is not necessary, this can complicate the data management

    if request_is_not_authorized
      return unauthorized_request
    end

    # puts "DEBUG-START"
    # puts "#{params}"
    # puts "DEBUG-END"

    reading = Reading.find_by(id: params[:id])
    reading.deleted = true
    reading.save
    render :json => {status: 'Record deleted'}

  end

  private

  def reading_params
    params.permit(:depth, :units_depth, :salinity, :units_salinity, :description)
  end

end
