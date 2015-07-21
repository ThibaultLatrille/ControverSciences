# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  process resize_to_limit: [1600, 1600], :if => :is_picture?

  def filename
    if model.picture.file
      "#{model.file_name}.#{model.picture.file.extension}"
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

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

   version :thumb do
     process :resize_to_fit => [250, 250]
   end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png svg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  protected

  def is_picture?(picture)
    return false if picture.content_type.include?('svg')
    picture.content_type.include?('image')
  end
end
