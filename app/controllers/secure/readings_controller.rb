class Secure::ReadingsController < Secure::ApplicationController
  def create
    logger.info "create; params=#{params}"

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

    if params[:latitude] != nil or params[:longitude] != nil
      if is_invalid_float_param(:latitude)
        return input_error(:latitude, 'invalid value')
      end

      if is_invalid_float_param(:longitude)
        return input_error(:longitude, 'invalid value')
      end

      if not params[:latitude].to_f.between?(-90, 90)
        return input_error(:latitude, 'out of range')
      end

      if not params[:longitude].to_f.between?(-180, 180)
        return input_error(:longitude, 'out of range')
      end
    end

    full_params = reading_params
    full_params[:approved] = false
    full_params[:deleted] = false
    reading = Reading.create(full_params)

    logger.info "create; result=success; reading_id=#{reading.id}"

    render :json => reading
  end

  def approve
    logger.info "approve; params=#{params}"

    reading = Reading.find_by(id: params[:id])

    if not reading
      return not_found('record not found')
    end

    if reading.deleted
      return not_found('already deleted')
    end

    reading.update!(approved: true)

    logger.info "approve; result=success; reading_id=#{reading.id};"

    return success
  end

  def delete
    logger.info "delete; params=#{params}"

    reading = Reading.find_by(id: params[:id])

    if not reading
      return not_found('record not found')
    end

    reading.delete!

    return success
  end

  private

  def reading_params
    params.permit(
        :depth,
        :units_depth,
        :salinity,
        :units_salinity,
        :description,
        :latitude,
        :longitude,
        :approved,
        :deleted
    )
  end
end
