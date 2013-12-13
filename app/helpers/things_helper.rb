# -*- coding: utf-8 -*-
require 'video_info'

module ThingsHelper
  def like_icon(thing)
    fa_icon "heart", text: "#{thing.count_by(:like)}"
  end

  def have_icon(thing)
    fa_icon "flag", text: "#{thing.count_by(:have)}"
  end

  def link_to_like_icon(thing)
    link_to thing_votes_path(thing, type: "like"), remote: true, method: "post", id: "like-#{thing.id}", "data-toggle" => "tooltip", title: "クリックで投票", style: "color: darkred" do like_icon thing end
  end

  def link_to_have_icon(thing)
    link_to thing_votes_path(thing, type: "have"), remote: true, method: "post", id: "have-#{thing.id}", "data-toggle" => "tooltip", title: "クリックで投票", style: "color: darkgreen;" do have_icon thing end
  end

  def link_to_like_li(thing)
    link_to thing_votes_path(thing, type: "like"), remote: true, method: "post", id: 'like', "data-toggle" => "tooltip", title: "クリックで投票" do fa_stacked_icon "heart-o", base: "square-o", text: "Like it (#{thing.count_by(:like)}人)", class: "fa-lg" end
  end

  def link_to_have_li(thing)
    link_to thing_votes_path(thing, type: "have"), remote: true, method: "post", id: 'have', "data-toggle" => "tooltip", title: "クリックで投票" do fa_stacked_icon "flag-o", base: "square-o", text: "Have it (#{thing.count_by(:have)}人)", class: "fa-lg" end
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

  def link_to_thing_small_img(thing)
    link_to thing_path(thing) do
      if thing.images.size > 0
        image_tag thing.images.first.thumb_url, class: "img-thumbnail img-responsive"
      else
        thing.name
      end
    end
  end

  def twitter?
    return false if not user_signed_in?
    return !current_user.get_auth(:twitter).blank?
  end

  def facebook?
    return false if not user_signed_in?
    return !current_user.get_auth(:facebook).blank?
  end

  def video_embed_code(thing)
    return if !thing.has_video?
    content_tag(:div, class: "video-container") do
      raw VideoInfo.new(thing.video).embed_code(iframe_attributes: { width: 560, height: 315 }, url_scheme: 'https')
    end
  end

  def rank_tag(thing)
    link_to "javascript:void(0)", "data-toggle" => "tooltip", title: "LikeやHaveで投票すると順位があがります", id: "rank" do
      fa_icon "rocket", text: "ランキング順位: #{thing.rank}位"
    end
  end
end
