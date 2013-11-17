class Thing < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :comments
  has_many :likes
  has_many :havables
  belongs_to :user
  accepts_nested_attributes_for :images

  default_scope { order('created_at DESC') }

  validates :name, presence: true, length: { maximum: 30 }
  validates :summary, presence: true
  validates :introduction, presence: true, length: { minimum: 20 }

  scope :sort_by_hot, -> {
    joins(:likes).reorder("count(likes.id) DESC").group("things.id")
  }

  scope :sort_by_new, -> {
    all
  }

  def youtube_id
    return $1 if video[/youtu\.be\/([^\?]*)/]
    return $5 if video[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
    nil
  end

  #http://www.ruanyifeng.com/blog/2012/02/ranking_algorithm_hacker_news.html
  def score(votes)
    t = (Time.zone.now - self.created_at) / (60 * 60)
    (votes - 1) / ((t + 2) ** 1.8)
  end
end
