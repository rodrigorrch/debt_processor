require_relative "boot"

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
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DebtProcessor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Use Sidekiq as the queuing backend for Active Job
    config.active_job.queue_adapter = :sidekiq

    # Configure Sidekiq-specific settings
    config.after_initialize do
      Sidekiq.configure_server do |config|
        config.redis = {
          url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0'),
          network_timeout: 5,
          timeout: 5,
          size: 27,
          reconnect_attempts: 3
        }
      end

      Sidekiq.configure_client do |config|
        config.redis = {
          url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0'),
          network_timeout: 5,
          timeout: 5,
          size: 5,
          reconnect_attempts: 3
        }
      end
    end

    # Ensure AASM models are properly loaded
    config.autoload_paths += %W(#{config.root}/app/models)
    config.eager_load_paths += %W(#{config.root}/app/models)

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
