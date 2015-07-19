require_relative 'spec_init'

describe "Settings" do
  specify "Includes the host" do
    settings = EventStore::Client::HTTP::Settings.build
    assert(settings.get.to_h.has_key? :host)
  end
  specify "Includes the port" do
    settings = EventStore::Client::HTTP::Settings.build
    assert(settings.get.to_h.has_key? :port)
  end
end
