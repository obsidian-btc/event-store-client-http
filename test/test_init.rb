ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'
ENV['LOG_LEVEL'] ||= 'trace'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'runner'
require 'fixture'

require 'controls/slice'
require 'controls/event_data'
require 'controls/event_data/storage'

TestLogger = Telemetry::Logger.get 'Test Output'

def logger(name)
  name = name.split('/').last
  Telemetry::Logger.get "-- TEST -- #{name}"
end
