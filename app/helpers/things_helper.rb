# -*- coding: utf-8 -*-
module ThingsHelper
  def like_icon(thing)
    fa_icon "heart", text: "#{thing.likes.size}"
  end

  def have_icon(thing)
    fa_icon "flag", text: "#{thing.havables.size}"
  end

  def link_to_like_icon(thing)
    link_to thing_likes_path(thing), remote: true, method: "post", id: "like-#{thing.id}", "data-toggle" => "tooltip", title: "クリックで投票", style: "color: darkred" do like_icon thing end
  end

  def link_to_have_icon(thing)
    link_to thing_havables_path(thing), remote:true, method: "post", id: "have-#{thing.id}", "data-toggle" => "tooltip", title: "クリックで投票", style: "color: darkgreen;" do have_icon thing end
  end

  def link_to_thing_thumbnail(thing)
    link_to thing_path(thing), class: "thumbnail" do
      if thing.images.size > 0
        image_tag thing.images.first.normal_url
      else
        thing.name
      end
    end
  end

  def twitter?(thing)
    return false if not user_signed_in?
    return false if current_user.authorizations.size == 0
    current_user.authorizations.last.provider == 'twitter'
  end

  def facebook?(thing)
    return false if not user_signed_in?
    return false if current_user.authorizations.size == 0
    current_user.authorizations.last.provider == 'facebook'
  end
end
