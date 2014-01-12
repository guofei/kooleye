class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :thing
  has_many :helpfulnesses, :dependent => :destroy

  validates :thing, presence: true
  validates :content, presence: true

  default_scope { order('created_at DESC') }

  def short_content(len = 50)
    return content if content.size < len
    content[0..len] + "..."
  end
end
