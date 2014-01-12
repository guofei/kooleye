class Helpfulness < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user

  validates :comment, presence: true
  validates :user, presence: true

  def duplication?
    not self.class.where(user_id: user_id, comment_id: comment_id).empty?
  end
end
