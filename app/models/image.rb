class Image < ActiveRecord::Base
  belongs_to :thing
  mount_uploader :file, FileUploader
  validates_presence_of :file
end
