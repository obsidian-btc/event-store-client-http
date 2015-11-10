# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-client-http'
  s.version = '0.1.7'
  s.summary = 'HTTP Client for EventStore'
  s.description = ' '

  s.authors = ['Obsidian Software, Inc']
  s.email = 'opensource@obsidianexchange.com'
  s.homepage = 'https://github.com/obsidian-btc/error_data'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'

  s.add_runtime_dependency 'casing'
  s.add_runtime_dependency 'clock'
  s.add_runtime_dependency 'connection'
  s.add_runtime_dependency 'controls'
  s.add_runtime_dependency 'dependency'
  s.add_runtime_dependency 'event_store-client'
  s.add_runtime_dependency 'http-protocol'
  s.add_runtime_dependency 'identifier-uuid'
  s.add_runtime_dependency 'settings'
  s.add_runtime_dependency 'schema'
  s.add_runtime_dependency 'telemetry-logger'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-spec-context'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'runner'
end
