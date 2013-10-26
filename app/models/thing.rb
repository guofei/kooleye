class Thing < ActiveRecord::Base
  has_many :images, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :images
end
