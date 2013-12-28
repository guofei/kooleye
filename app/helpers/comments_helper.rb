module CommentsHelper
  def link_to_comment_user_page(comment)
    return link_to_user_page comment.user if comment.user
    if comment.name.blank?
      return "Guest"
    else
      return comment.name[0..10]
    end
  end
end
