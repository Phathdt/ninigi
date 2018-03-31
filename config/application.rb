require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Ninigi
  class Application < Rails::Application
    config.load_defaults 5.1

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators.system_tests = nil

    config.api_only = true

    config.autoload_paths += %W(#{config.root}/config/routes)

    config.active_job.queue_adapter     = :delayed_job

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, :methods => [:get, :post, :options]
      end
    end
  end
end
