PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

require 'simplecov'

require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'capybara'
require 'capybara/dsl'
require 'webmock/rspec'

# RSpec's helpers 
# It aims to add support for rspec tests
Dir.glob(File.dirname(__FILE__) + "/support/**/*.rb").each {|f| require f}

Capybara.app = Alfred::App

RSpec.configure do |conf|
	DataMapper.auto_migrate!
  conf.include Rack::Test::Methods
	conf.include Capybara
end

VCR.configure do |c|  
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  Alfred::App.tap { |app|  }
  Alfred::App.set :protect_from_csrf, false
end
