class Secure::PhotosController < Secure::ApplicationController
  def create
    if not params[:image]
      return input_error(:image)
    end

    if is_invalid_float_param(:category)
      return input_error(:category, 'invalid value')
    end

    if not Photo::Category.is_valid(params[:category].to_i)
      return input_error(:category, 'out of range')
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
