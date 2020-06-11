require_relative 'boot'

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tan5
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.time_zone = "Tokyo"
    config.i18n.load_path += 
      Dir[Rails.root.join("config","locales","**","*.{rb,yml}").to_s]
      config.i18n.default_locale = :ja
    config.generators do |g|
      g.skip_routes true
      g.helper false
      g.assets false
      g.test_framework :rspec
      g.controller_spaces false
      g.view_space false
    end
    config.web_console.whitelisted_ips = "10.0.2.2"
  end
end
