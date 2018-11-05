require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CryptoCalculator
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = 'Bogota'
    config.active_record.default_timezone = :local
    config.i18n.available_locales = [:es, :en]
    config.i18n.default_locale = :es
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :delete, :put, :options]
      end
    end    
    
    # Enable CORS
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options, :put, :patch, :delete]
      end
    end

  end
end
