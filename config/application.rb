require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "curriculum_vitae", "curricula_vitae"
end

module Seminaria
  class Application < Rails::Application
    config.load_defaults 8.1
    config.unibo_common = config_for(:unibo_common)

    config.hosts << config.unibo_common.host

    config.time_zone = "Rome"
    config.i18n.default_locale = :it

    config.authlevels = {
      read: 1,
      manage: 2
    }

    Rails.application.routes.default_url_options = {
      host: config.unibo_common.host,
      protocol: "https"
    }
  end
end
