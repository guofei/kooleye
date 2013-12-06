class Thing < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :comments
  has_many :votes
  has_many :havables
  belongs_to :user
  accepts_nested_attributes_for :images

  default_scope { order('created_at DESC') }

  validates :name, presence: true, length: { maximum: 30 }
  validates :summary, presence: true
  validates :introduction, presence: true, length: { minimum: 20 }
  validates :images, :length => { :minimum => 1, :message => I18n.t("view.thing.image-error") }

  scope :sort_by_hot, -> {
    joins(:votes).reorder("count(votes.id) DESC").group("things.id")
  }

  scope :sort_by_new, -> {
    all
  }

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless self.class.where(token: random_token).exists?
    end
  end

  def other_things(n = 9)
    return self.class.sort_by_hot.take(n) if not user
    size = user.things.size > n ? n/2 : user.things.size
    user.things.take(size) + self.class.sort_by_hot.take(n - size)
  end

  def count_by(type)
    votes.select { |v| v.vote_type == type.to_s }.count
  end

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
