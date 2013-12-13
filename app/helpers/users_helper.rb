module UsersHelper
  def link_to_user_mini_image(user)
    return if user.blank? or user.url.blank? or user.image.blank?
    link_to user.url do image_tag user.image.gsub('normal.', 'mini.') end
  end

  def link_to_user_page(user)
    return "Guest" if user.blank?
    if user.url.blank? or user.name.blank?
      user.email.split("@")[0]
    else
      link_to user.name, user.url
    end
  end

  def link_to_user_image(user)
    if user.blank? or user.url.blank? or user.name.blank?
      link_to "#", class: "pull-left" do image_tag "none.png" end
    else
      link_to user.url, class: "pull-left" do image_tag user.image end
    end
  end
end
