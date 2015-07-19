require_relative 'spec_init'

describe "ATOM Document" do
  specify "Enumerating entries" do
    atom_text = Fixtures::ATOM::Document.text
    doc = EventStore::Client::HTTP::ATOM::Document.build(atom_text)

    doc.each_entry do |entry|
      assert(entry.is_a? EventStore::Client::HTTP::Stream::Entry)
    end
  end
end
