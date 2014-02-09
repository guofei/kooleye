require 'uri'

module RedirectHelper
  def aff_link(url)
    redirect_index_path + "?u=#{Base64.urlsafe_encode64(url)}"
  end
end
