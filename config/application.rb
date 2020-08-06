require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dossier
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource(
          '*',
          headers: :any,
          methods: %i[get patch put delete post options]
        )
      end
    end

    initializer :configure_metrics, after: :finisher_hook do
      expresion = ENV['NOTIFICATIONS_SUSCRIBE_REGEX'] || '.'
      ActiveSupport::Notifications.subscribe(/#{expresion}/) do |event|
        Rails.logger.error('"' + File.basename($PROGRAM_NAME) + '"')
        base = File.basename($PROGRAM_NAME)
        unless base[0..9] == 'spring app' || %w[rspec rake rails_destroy rails_generate].include?(base)
          metric_prefix = KarafkaApp.config.client_id + '.' + event.name
          logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
          logger.level = Logger::DEBUG
          logger.tagged(KarafkaApp.config.client_id, event.name, Time.now.to_i) { logger.info(event.as_json) }
          logger = nil
          StatsD.measure(metric_prefix + '.duration', event.duration)
          StatsD.measure(metric_prefix + '.allocations', event.allocations)
          StatsD.increment(metric_prefix)
        end
      end
    end
  end
end
