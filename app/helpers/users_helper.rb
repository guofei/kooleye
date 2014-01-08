module UsersHelper
  def link_to_user_image(user)
    if user.blank?
      link_to "#", class: "pull-left" do image_tag "none.png" end
    else
      user.image = "none.png" if user.image.blank?
      link_to user_page_path(user), class: "pull-left", target: "_blank" do image_tag user.image end
    end
  end

  def link_to_user_mini_image(user)
    if user.blank?
      link_to "#", class: "pull-left" do image_tag "none.png" end
    else
      user.image = "none.png" if user.image.blank?
      link_to user_page_path(user), target: "_blank" do image_tag user.image.gsub('normal.', 'mini.') end
    end
  end

  def link_to_user_sns_image(user)
    if user.blank? or user.url.blank? or user.name.blank? or user.image.blank?
      link_to "#", class: "pull-left" do image_tag "none.png" end
    else
      link_to user.url, class: "pull-left", target: "_blank" do image_tag user.image end
    end
  end

  def link_to_user_sns_mini_image(user)
    return if user.blank? or user.url.blank?
    user.image = "none.png" if user.image.blank?
    link_to user.url, target: "_blank" do image_tag user.image.gsub('normal.', 'mini.') end
  end

  def link_to_user_page(user)
    return "Guest" if user.blank?
    link_to username(user), user_page_path(user), target: "_blank"
  end

  def link_to_user_sns_page(user)
    return "Guest" if user.blank?
    link_to username(user), user_page_path(user), target: "_blank"
  end

  def user_name_or_email(user)
    return user.email if user.name.blank?
    user.name
  end

  def username(user)
    return "Guest" if user.blank?
    if user.name.blank?
      user.email.split("@")[0]
    else
      user.name
    end
  end
end
