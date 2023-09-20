require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GlobalEducacional
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    I18n.available_locales = %i[en pt]

    config.i18n.default_locale = :pt

    config.time_zone = 'America/Sao_Paulo'
  end
end
