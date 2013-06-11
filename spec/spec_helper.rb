PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'capybara'
require 'capybara/dsl'

# RSpec's helpers 
# It aims to add support for rspec tests
Dir.glob(File.dirname(__FILE__) + "/support/**/*.rb").each {|f| require f}


Capybara.app = Alfred::App

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
	conf.include Capybara
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  Alfred::App.tap { |app|  }
end
