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
    config.load_defaults 7.1

    config.hosts += ENV.fetch("ALLOWED_HOSTS", "").split(",")

    config.time_zone = "Rome"
    config.i18n.default_locale = :it

    config.authlevels = {read: 1, manage: 2}

    config.cache_store = :memory_store, {size: 64.megabytes}

    config.action_mailer.default_url_options = {protocol: "https"}
    config.unibo_common = config_for(:unibo_common)
  end
end
