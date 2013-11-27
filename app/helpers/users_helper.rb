module UsersHelper
  def link_to_user_mini_image(user)
    return if user.blank? or user.url.blank? or user.image.blank?
    link_to user.url do image_tag user.image.gsub('normal.', 'mini.') end
  end
end
