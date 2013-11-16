module ThingsHelper
  def link_to_thing_thumbnail(thing)
    link_to thing_path(thing), class: "thumbnail" do
      if thing.images.size > 0
        image_tag thing.images.first.normal_url
      else
        thing.name
      end
    end
  end
end
