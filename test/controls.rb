require_relative 'test_init'

Runner.! 'controls/**/*.rb' do |exclude|
  exclude =~ /(_init.rb|\.scratch.rb)\z/
end
