Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Set to true for production
  config.cache_classes = true

  # Do not eager load code on boot.
  #
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  #
  config.assets.debug = false

  
  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  
  # Raises error for missing translations
   config.action_view.raise_on_missing_translations = false
  
  config.action_mailer.raise_delivery_errors = false
  

 # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
  
  #Devise
  ::SITE_DOMAIN = "tldwmovies.com"
  
  config.action_mailer.default_url_options = { :host => 'www.tldwmovies.com' }
  #if heroku errors do this
  #Rails.application.routes.default_url_options[:host] = 'yoursite.herokuapp.com'
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"

    config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: ENV["GMAIL_DOMAIN"],
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"]
    }
  
end
