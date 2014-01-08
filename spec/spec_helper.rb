if ENV['RACK_COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'infochimps/rack'

Goliath.run_app_on_exit = false
