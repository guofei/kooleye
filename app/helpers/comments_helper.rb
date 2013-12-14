module CommentsHelper
  def link_to_comment_user_page(comment)
    return link_to_user_page comment.user if comment.user
    return comment.name[0..10] if comment.name
    return "Guest"
  end
end
