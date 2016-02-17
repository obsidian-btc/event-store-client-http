require_relative 'bench_init'

context "Settings" do
  test "Includes the host" do
    settings = EventStore::Client::HTTP::Settings.build
    assert(settings.get.to_h.has_key? :host)
  end
  test "Includes the port" do
    settings = EventStore::Client::HTTP::Settings.build
    assert(settings.get.to_h.has_key? :port)
  end
end
