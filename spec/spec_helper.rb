PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
	conf.before(:each) { DataMapper.auto_migrate! }
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  Alfred::App.tap { |app|  }
end
