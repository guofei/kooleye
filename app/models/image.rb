class Image < ActiveRecord::Base
  belongs_to :thing
  mount_uploader :file, FileUploader
  validates_presence_of :file

  def url
    file.url
  end

  def normal_url
    file.normal.url
  end

  def thumb_url
    file.thumb.url
  end
end
