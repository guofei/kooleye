module ApplicationHelper
  #ref: http://stackoverflow.com/questions/5909121/converting-a-regular-youtube-link-into-an-embedded-video
  def youtube_embed(thing)
    if not thing.youtube_id.nil?
      content_tag(:div, class: "video-container") do
        content_tag(:iframe, '', src: "http://www.youtube.com/embed/#{thing.youtube_id}", frameborder: "0", width: "560", height: "315")
      end
    end
  end
end
