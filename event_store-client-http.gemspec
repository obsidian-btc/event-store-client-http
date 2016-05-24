# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-client-http'
  s.version = '0.4.0.1'
  s.summary = 'HTTP Client for EventStore'
  s.description = ' '

  s.authors = ['Obsidian Software, Inc']
  s.email = 'opensource@obsidianexchange.com'
  s.homepage = 'https://github.com/obsidian-btc/event-store-client-http'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY

  s.add_runtime_dependency 'casing'
  s.add_runtime_dependency 'connection-client'
  s.add_runtime_dependency 'event_store-client'
  s.add_runtime_dependency 'http-commands'
  s.add_runtime_dependency 'schema'
  s.add_runtime_dependency 'serialize'
  s.add_runtime_dependency 'settings'

  s.add_development_dependency 'test_bench'
end
