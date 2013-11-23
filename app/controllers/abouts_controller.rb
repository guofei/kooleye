class AboutsController < ApplicationController
  def show
    @about = About.find(params[:id])
  end
end
