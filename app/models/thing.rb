class Thing < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :comments
  has_many :likes
  belongs_to :user
  accepts_nested_attributes_for :images

  default_scope { order('created_at DESC') }

  validates :name, presence: true, length: { maximum: 30 }
  validates :summary, presence: true
  validates :introduction, presence: true, length: { minimum: 20 }
end
