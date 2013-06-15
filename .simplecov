SimpleCov.start do
  root(File.join(File.dirname(__FILE__)))

  add_filter '/spec/'
  add_filter '/features/'
  add_filter '/admin/'
  add_filter '/fixtures/'
  add_filter '/config/'

  add_group "Models", "models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
end