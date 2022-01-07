require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'curriculum_vitae', 'curricula_vitae'
end

module Seminaria
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.hosts << "tester.dm.unibo.it"
    config.hosts << "www.dm.unibo.it"

    config.autoload_paths += %W(#{Rails.root}/app/pdfs)
    config.time_zone = 'Rome'
    config.i18n.default_locale = :it

    config.authlevels = {read: 1, manage: 2}

    config.dm_unibo_common = ActiveSupport::HashWithIndifferentAccess.new config_for(:dm_unibo_common)

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
