require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GlobalEducacional
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    I18n.available_locales = %i[pt]

    config.i18n.default_locale = :pt

    config.time_zone = 'America/Sao_Paulo'

    # Access-Control-Allow-Origin
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3000', /https*:\/\/.*?viacep\.com/
        resource '*', :headers => :any, :methods => :any
      end
    end
  end
end
