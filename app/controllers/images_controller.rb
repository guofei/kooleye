class ImagesController < ApplicationController
  before_filter :authenticate_user!
  def create
    @image = Image.create(image_params)
  end

  def destroy
    @image = Image.find(params[:id])
    @destroy_id = @image.id
    @image.destroy
  end

  private
  def image_params
    params.require(:image).permit(:file, :thing_token)
  end
end
