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

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    config.hosts << "tester.dm.unibo.it"
    config.hosts << "www.dm.unibo.it"

    config.autoload_paths << "#{Rails.root}/app/pdfs"
    config.time_zone = "Rome"
    config.i18n.default_locale = :it

    config.authlevels = {read: 1, manage: 2}

    config.action_mailer.default_url_options = {protocol: "https"}
    config.dm_unibo_common = ActiveSupport::HashWithIndifferentAccess.new config_for(:dm_unibo_common)
  end
end
