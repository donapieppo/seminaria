# require "omniauth-shibboleth"
# require "omniauth-azure-activedirectory-v2"
# require "omniauth-google-oauth2"
require "dm_unibo_common/omniauth/strategies/test"

Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = "/dm_unibo_common/auth"
  end

  if Rails.env.development?
    provider :developer, {
      fields: [:upn, :name, :surname],
      uid_field: :upn
    }
  end

  if Rails.env.test?
    provider :test
  end
end
