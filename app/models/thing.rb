require 'video_info'

class Thing < ActiveRecord::Base
  has_many :images, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :comments, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :votes, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :images

  default_scope { order('created_at DESC') }

  validates :name, presence: true, length: { maximum: 30 }
  validates :summary, presence: true
  validates :introduction, presence: true, length: { minimum: 20 }
  validates :images, :length => { :minimum => 1, :message => I18n.t("view.thing.image-error") }

  scope :sort_by_hot_and_time, -> {
    includes(:votes).load.sort{|t1, t2| t2.score <=> t2.score }
  }

  scope :sort_by_hot, -> {
    joins('left join votes on votes.thing_id = things.id').reorder("count(votes.id) DESC").group("things.id")
  }

  def rank
    index = self.class.sort_by_hot.index(self)
    return index + 1 if index
    return self.class.all.size + 1
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless self.class.where(token: random_token).exists?
    end
  end

  def other_things(n = 9)
    return self.class.sort_by_hot.take(n) if not user
    size = user.things.size > n ? n/2 : user.things.size
    (user.things.take(size) + self.class.sort_by_hot.take(n - size)).uniq
  end

  def count_by(type)
    votes.select { |v| v.vote_type == type.to_s }.count
  end

  def has_video?
    begin
      VideoInfo.new(video)
      return true
    rescue VideoInfo::UrlError => e
      return false
    end
  end

  #http://www.ruanyifeng.com/blog/2012/02/ranking_algorithm_hacker_news.html
  def score
    t = (Time.zone.now - self.created_at) / (60 * 60)
    (self.votes.size - 1) / ((t + 2) ** 1.8)
  end
end
