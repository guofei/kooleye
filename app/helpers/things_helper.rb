module ThingsHelper
  def link_to_thing_thumbnail(thing)
    link_to thing_path(thing), class: "thumbnail" do
      image_tag thing.images.first.file.normal
    end
  end
end
