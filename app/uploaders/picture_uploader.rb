# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  process resize_to_fill: [640, 640], :if => :is_profil_picture?
  process :fit_size
  process :store_dimensions

  def filename
    if model.picture.file
      "#{model.file_name}.#{file.extension}"
    end
  end

  if Rails.env.production?
  # Choose what kind of storage to use for this uploader:
    storage :fog
    def store_dir
      "uploads/#{model.user_name}"
    end
  end

  if Rails.env.development?
    # Choose what kind of storage to use for this uploader:
    storage :file
    def store_dir
      "#{Rails.public_path}/uploads"
    end
  end

   version :medium do
     process :quality => 50
   end

  def extension_white_list
    %w(jpg jpeg gif png svg)
  end

  private

  def store_dimensions
    if file && model
      model.file_size = file.size
      if is_image?(self)
        model.is_image = true
        model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
      else
        model.is_image = false
      end
    end
  end

  def fit_size
    if is_image?(self)
      if size > 3.megabytes
        quality(60)
      elsif size > 2.megabytes
        quality(70)
      elsif size > 1500.kilobytes
        quality(80)
      elsif size > 1000.kilobytes
        quality(85)
      elsif size > 750.kilobytes
        quality(90)
      elsif size > 500.kilobytes
        quality(95)
      end
    end
  end

  protected

  def is_image?(picture)
    return false if picture.content_type.include?('svg')
    picture.content_type.include?('image')
  end

  def is_profil_picture?(picture)
    is_image?(self) && model.profil ? true : false
  end

end
