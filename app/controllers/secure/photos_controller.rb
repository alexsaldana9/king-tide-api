class Secure::PhotosController < Secure::ApplicationController
  def create
    if params[:image] == nil
      return input_error(:image)
    end

    # 1-depth, 2-salinity, 3-location, 4-other
    if not params[:category].to_f.between?(1, 4)
      return input_error(:category)
    end

    if is_invalid_float_param(:reading_id)
      return input_error(:reading_id, 'invalid value')
    end

    reading = Reading.find_by_id(params[:reading_id])
    if not reading
      return input_error(:reading_id, 'not found')
    end

    if reading.deleted
      return not_found('already deleted')
    end

    if reading.approved
      return input_error(:reading_id, 'approved readings cannot be changed')
    end

    photo = Photo.create(photo_params)
    if not photo.valid?
      return client_error 'Photo not saved'
    end

    p "create; result=success; photo_id=#{photo.id}, reading_id=#{reading.id}"
    return success
  end

  private

  def photo_params
    params.permit(:image, :reading_id, :category)
  end

end
