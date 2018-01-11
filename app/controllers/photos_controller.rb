class PhotosController < ApplicationController

  def create
    if request_is_not_authorized
      return unauthorized_request
    end

    if params[:image] == nil
      return input_error(:image)
    end

    if is_invalid_float_param(:reading_id)
      return input_error(:reading_id)
    end

    if not Reading.exists?(id: params[:reading_id].to_i)
      return input_error(:reading_id)
    end

    photo = Photo.create(photo_params)
    if not photo.valid?
      return render :json => {error: 'Photo not saved'}, status: 400
    end

    render :json => {result: :ok}
  end

  private

  def photo_params
    params.permit(:image, :reading_id)
    # params.require(:photo).permit(:image, :reading_id)
  end

end
