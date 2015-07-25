require_relative 'spec_init'

Runner.! 'database_integration/**/*.rb' do |exclude|
  exclude =~ /(_init.rb|\.scratch.rb)\z/
end
