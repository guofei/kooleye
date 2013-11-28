module UsersHelper
  def link_to_user_mini_image(user)
    return if user.blank? or user.url.blank? or user.image.blank?
    link_to user.url do image_tag user.image.gsub('normal.', 'mini.') end
  end

  def link_to_user_page(user)
    if user.url.blank? or user.name.blank?
      user.email.split("@")[0]
    else
      link_to user.name, user.url
    end
  end
end
