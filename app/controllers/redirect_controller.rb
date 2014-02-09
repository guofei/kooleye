class RedirectController < ApplicationController
  def index
    url = params[:u]
    redirect_to Base64.urlsafe_decode64(url)
  end
end
