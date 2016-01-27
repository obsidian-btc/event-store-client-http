require_relative 'spec_init'

context 'Session' do
  test 'Varying the settings used for construction' do
    settings = Settings.build(
      'some_namespace' => {
        'host' => 'www.example.com',
        'port' => 8080
      }
    )

    session = EventStore::Client::HTTP::Session.build settings, 'some_namespace'

    assert session.host == 'www.example.com'
    assert session.port == 8080
  end
end
