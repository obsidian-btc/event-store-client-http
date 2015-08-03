require_relative 'test_init'

Runner.! 'spec/**/*.rb' do |exclude|
  exclude =~ /integration\.rb|(_init.rb|\.scratch.rb|\.skip\.rb)\z/
end
