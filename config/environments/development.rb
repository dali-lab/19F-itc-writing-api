Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  config.public_file_server.enabled = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # config.action_mailer.perform_caching = false

  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.default_url_options = { host: 'localhost:3000' }


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  config.active_record.sqlite3.represent_boolean_as_integer = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Generate digests for assets URLs
  config.assets.digest = false

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # enable logging of partials
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.action_view.logger = ActiveSupport::TaggedLogging.new(logger)
  # log as much detail as possible
  config.log_level = :debug

  # Stop rails generators creating files we don't use, and do create rspec tests
  # rails generate model Widget  (rails destroy model Widget)
  # rails generate controller Widget  (rails destroy controller Widget)
  # rails generate scaffold Widget  (rails destroy scaffold Widget)
  config.generators do |g|
    g.scaffold_stylesheet false
    g.assets          false
    g.helper          false
    g.javascripts     false
    g.stylesheets     false
    g.jbuilder        false
    g.orm             :active_record
    g.template_engine :slim # or :erb
    g.test_framework  :rspec
    g.integration_tool :rspec
    g.view_specs      false
    g.routing_specs   false
    g.controller_specs      false
    g.fixture_replacement :factory_bot, dir: 'spec/factories'
  end

end
