if ENV['RACK_COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'infochimps/rack'
