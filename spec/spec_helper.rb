if ENV['RACK_COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'goliath/chimp'

Goliath.run_app_on_exit = false
