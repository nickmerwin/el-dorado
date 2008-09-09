RAILS_GEM_VERSION = '2.1' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')
require 'rails_generator/secret_key_generator'
require 'open-uri'
require 'yaml'

Rails::Initializer.run do |config|    
  config.time_zone = 'UTC'
  config.active_record.partial_updates = true
end

# Your cookie sessions configuration is read from config/database.yml or automatically generated
if Configurator[:session_key].blank? && Configurator[:session_secret].blank?
  db = YAML.load_file('config/database.yml')
  if db[RAILS_ENV]['session_key'] && db[RAILS_ENV]['secret']
    Configurator[:session_key] = db[RAILS_ENV]['session_key']
    Configurator[:session_secret] = db[RAILS_ENV]['secret']
  else
    Configurator[:session_key] = Rails::SecretKeyGenerator.new(rand).generate_secret
    Configurator[:session_secret] = Rails::SecretKeyGenerator.new(rand).generate_secret
  end
end
ActionController::Base.session_options[:session_key] = Configurator[:session_key]
ActionController::Base.session_options[:secret] = Configurator[:session_secret]
