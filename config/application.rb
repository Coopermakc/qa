require_relative 'boot'
require 'parser/current'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qa
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded
    #config.autoload_paths += %w(#{config.root}/app/jobs)
    config.active_job.queue_adapter = :sidekiq
    config.generators do |g|
      g.test_framework :rspec,
                        fixtures: true,
                        view_spec: false,
                        helper_specs: false,
                        routing_specs: false,
                        request_specs: false,
                        controller_specs: true
      g.fixtures_replacement :factory_bot, dir: 'spec/factories'
    end
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
