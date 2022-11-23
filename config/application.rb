require_relative "boot"

require "rails/all"

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

    require 'ext/string'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    I18n.enforce_available_locales = true
    I18n.available_locales = :en, :fr
    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    I18n.default_locale = :fr
  end
end
