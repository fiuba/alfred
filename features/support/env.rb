PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

require File.expand_path(File.dirname(__FILE__) + "/../../config/boot")

require 'capybara/cucumber'
require 'rspec/expectations'

require 'simplecov'
require 'webmock/rspec'

require File.expand_path(File.dirname(__FILE__) + "/storage")

##
# You can handle all padrino applications using instead:
#   Padrino.application
#Capybara.default_driver = :selenium

Capybara.app = Alfred::App.tap { |app|  }

VCR.configure do |c|  
  c.cassette_library_dir = 'fixtures/acceptance_cassettes'
  c.hook_into :webmock
end

Before do
  DataMapper.auto_migrate!
  StorageHelpers.set_up_environment
  MailerHelper.clear
end
