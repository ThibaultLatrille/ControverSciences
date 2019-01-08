require 'fog/aws'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
        # Configuration for Amazon S3
        :provider => 'AWS',
        :aws_access_key_id => ENV['S3_ACCESS_KEY'],
        :aws_secret_access_key => ENV['S3_SECRET_KEY'],
        :region => 'eu-central-1'
    }
    config.fog_directory = ENV['S3_BUCKET']
  end
end
if Rails.env.development?
  CarrierWave.configure do |config|
    config.root = Rails.root
  end
end
module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end