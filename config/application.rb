require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # TODO Stop-gap workaround to carrierwave doing "require 'fog'"
    # This let's us get ./lib in the load path, where our own
    # fog.rb is loaded for carrierwave, but we've already loaded
    # fog-aws, which is all we need anyway.
    config.before_configuration do
      require 'carrierwave'
    end

    config.assets.paths << "#{Rails}/vendor/assets/fonts"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    I18n.enforce_available_locales = true
    I18n.available_locales = :en, :fr
    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    I18n.default_locale = :fr
  end
end
