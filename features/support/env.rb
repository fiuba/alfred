require File.expand_path(File.dirname(__FILE__) + "/../../config/boot")

require 'capybara/cucumber'
require 'rspec/expectations'

require 'simplecov'

SimpleCov.start do
  root(File.join(File.dirname(__FILE__), '../../'))
  add_filter '/spec/'
  add_filter '/features/'
end

##
# You can handle all padrino applications using instead:
#   Padrino.application
Capybara.default_driver = :selenium
Capybara.app = Alfred::App.tap { |app|  }
