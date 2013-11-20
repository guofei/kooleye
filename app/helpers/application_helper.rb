module ApplicationHelper
  def title(page_title)
      content_for :title, page_title.to_s
  end

  def youtube_embed(thing)
    content_tag(:div, class: "video-container") do
      content_tag(:iframe, '', src: "http://www.youtube.com/embed/#{thing.youtube_id}", frameborder: "0", width: "560", height: "315")
    end
  end
end
