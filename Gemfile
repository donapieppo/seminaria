source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "dm_unibo_user_search", git: "https://github.com/donapieppo/dm_unibo_user_search.git"
gem "dm_unibo_common", git: "https://github.com/donapieppo/dm_unibo_common.git", branch: "master"
# gem "dm_unibo_common", path: "/home/rails/gems/dm_unibo_common/"

gem "sentry-ruby"
gem "sentry-rails"

gem "jsbundling-rails"
gem "cssbundling-rails"

gem "prawn"
gem "prawn-table"
gem "caracal"
gem "caracal-rails"

gem "roo"
gem "roo-xls"

gem "omniauth-rails_csrf_protection"

gem "aws-sdk-s3", require: false

gem "lograge"
gem "logstash-event"

gem "pry"
gem "csv"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "ruby-lsp", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  # gem "sqlite3"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
