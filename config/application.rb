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

require './lib/log_formatter'

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

    # all log outputs are going to be in json format, and only last 5 log files of 10mb are going to be kept
    # config.logger = ActiveSupport::Logger.new(config.paths["log"].first, 5, 10 * 1024 * 1024)

    # hack para obtener el request_id
    # https://github.com/roidrage/lograge/issues/255#issuecomment-657328032
    logger = ActiveSupport::Logger.new(config.paths["log"].first, 5, 10 * 1024 * 1024)
    logger.formatter = LogFormatter.new
    config.log_tags = [:request_id]
    config.logger = ActiveSupport::TaggedLogging.new(logger)
    
    # para evitar errores al recibir las solicitudes ruteadas por nginx
    config.hosts.clear

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

    # initializer :configure_metrics, after: :finisher_hook do
    #   expresion = ENV['NOTIFICATIONS_SUSCRIBE_REGEX'] || '.'
    #   ActiveSupport::Notifications.subscribe(/#{expresion}/) do |event|
    #     # Rails.logger.error('"' + File.basename($PROGRAM_NAME) + '"')
    #     base = File.basename($PROGRAM_NAME)
    #     unless base[0..9] == 'spring app' || %w[rspec rake rails_destroy rails_generate].include?(base)

    #       logger = Rails.logger

    #       nombre_cliente = KarafkaApp.config.client_id
    #       nombre_evento = event.name
    #       hora = Time.now.to_i

    #       if nombre_evento.match(/action_controller/)
    #         # logger.info(event.payload[:headers]['action_dispatch.request_id'])
    #         logger.info(event.payload.to_json)
    #       end

    #       metric_prefix = KarafkaApp.config.client_id + '.' + event.name
    #       StatsD.measure(metric_prefix + '.duration', event.duration)
    #       StatsD.measure(metric_prefix + '.allocations', event.allocations)
    #       StatsD.increment(metric_prefix)
    #     end
    #   end
    # end
  end
end
