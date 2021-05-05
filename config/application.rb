require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TransparencyHub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.



    config.autoload_paths += Dir[File.join(Rails.root, "app", "services", "open_api_services", "*.rb")].each {|l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, "app", "services", "tira", "*.rb")].each {|l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, "app", "services", "tira", "tira", "*.rb")].each {|l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, "app", "services", "tira", "tira", "*.rb")].each {|l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, "app", "services", "tira", "tira", "personal_datum", "*.rb")].each {|l| require l }
    config.autoload_paths += Dir[File.join(Rails.root, "app", "services", "tira", "tira", "property", "*.rb")].each {|l| require l }
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '**/',) ]
  end
end
