# -*- coding: utf-8 -*-
module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def timeago(t)
    humanword = time_ago_in_words t
    return humanword if humanword.include? "以" or humanword.include? "未満"
    humanword + "前"
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
