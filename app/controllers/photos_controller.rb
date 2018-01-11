class PhotosController < ApplicationController

  def create
    # @photo = Photo.new(photo_params)
    #
    # if @photo.save
    #   redirect_to @photo, notice: 'Photo was successfully uploaded.'
    # else
    #   render action: 'new'
    # end

    photo = Photo.create(photo_params)

    render :json => photo
  end


  private

  def photo_params
    params.permit(:image, :reading_id)
    # params.require(:photo).permit(:image, :reading_id)
  end

end
