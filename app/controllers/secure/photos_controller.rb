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
      return input_error(:reading_id)
    end

    if not Reading.exists?(id: params[:reading_id].to_i)
      return input_error(:reading_id)
    end

    photo = Photo.create(photo_params)
    if not photo.valid?
      return client_error 'Photo not saved'
    end

    return success
  end

  private

  def photo_params
    params.permit(:image, :reading_id, :category)
  end

end
