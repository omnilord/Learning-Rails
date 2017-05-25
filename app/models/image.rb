class Image < ActiveRecord::Base
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validate :picture_size

  def height
    picture_dimensions[0]
  end

  def width
    picture_dimensions[1]
  end

  def scale(h, w)
    if width > w && height < width
      w = height * (w / width.to_f)
    elsif height > h && width < height
      h = width * (h / height.to_f)
    end

    "#{w.to_i}x#{h.to_i}"
  end

private

  def picture_size
    errors.add(:picture, 'Max upload size is 5MB') if picture.size > 5.megabytes
  end

  def picture_dimensions
    @dimensions ||= ::MiniMagick::Image.open(picture.file.file)[:dimensions]
  end
end
