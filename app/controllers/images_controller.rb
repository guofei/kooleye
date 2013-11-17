class ImagesController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.js
      end
    end
  end

  private
  def image_params
    params.require(:image).permit(:file)
  end
end
