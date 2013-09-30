PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

require File.expand_path(File.dirname(__FILE__) + "/../../config/boot")

require 'capybara/cucumber'
require 'rspec/expectations'

require 'simplecov'
require 'webmock/rspec'

##
# You can handle all padrino applications using instead:
#   Padrino.application
#Capybara.default_driver = :selenium
Capybara.app = Alfred::App.tap { |app|  }

VCR.configure do |c|  
  c.cassette_library_dir = 'fixtures/asseptance_cassettes'
  c.hook_into :webmock
end

Before do
  DataMapper.auto_migrate!

	ENV['DROPBOX_APP_KEY']='12345abcde'
	ENV['DROPBOX_APP_SECRET']='12345abcde'
	ENV['DROPBOX_REQUEST_TOKEN_KEY']='12345abcde'
	ENV['DROPBOX_REQUEST_TOKEN_SECRET']='12345abcde'
	ENV['DROPBOX_AUTH_TOKEN_KEY']='12345abcde'
	ENV['DROPBOX_AUTH_TOKEN_SECRET']='12345abcde'
end
