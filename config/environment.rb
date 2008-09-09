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
db = YAML.load_file('config/database.yml')
if db[RAILS_ENV]['session_key'] && db[RAILS_ENV]['secret']
  session_key    = db[RAILS_ENV]['session_key']
  session_secret = db[RAILS_ENV]['secret']
else
  session_key    = Rails::SecretKeyGenerator.new(rand).generate_secret
  session_secret = Rails::SecretKeyGenerator.new(rand).generate_secret
end
ActionController::Base.session_options[:session_key] = session_key
ActionController::Base.session_options[:secret] = session_secret
# Store cookie sessions config, rescue for initial running of configurator migration
begin; Configurator[:session_key] = session_key; Configurator[:session_secret] = session_secret; rescue; end