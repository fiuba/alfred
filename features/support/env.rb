require File.expand_path(File.dirname(__FILE__) + "/../../config/boot")

require 'capybara/cucumber'
require 'rspec/expectations'

require 'simplecov'

##
# You can handle all padrino applications using instead:
#   Padrino.application
Capybara.default_driver = :selenium
Capybara.app = Alfred::App.tap { |app|  }
