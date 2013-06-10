PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'capybara'
require 'capybara/dsl'

Capybara.app = Sinatra::Application

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
	conf.before(:each) { DataMapper.auto_migrate! }
	conf.include Capybara
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  Alfred::App.tap { |app|  }
end
