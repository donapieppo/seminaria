require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'curriculum_vitae', 'curricula_vitae'
end

module Seminaria
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.hosts << "tester.dm.unibo.it"
    config.hosts << "www.dm.unibo.it"

    config.autoload_paths += %W(#{Rails.root}/app/pdfs)
    config.time_zone = 'Rome'
    config.i18n.default_locale = :it

    config.authlevels = {read: 1, manage: 2}
          
    config.action_mailer.default_url_options = {protocol: 'https'}
    config.dm_unibo_common = ActiveSupport::HashWithIndifferentAccess.new config_for(:dm_unibo_common)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
