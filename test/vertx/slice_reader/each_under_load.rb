require_relative './slice_reader_init'

stream_name = Fixtures::EventData.write 3_000, 'testSliceReaderEach'

logger(__FILE__).info stream_name

reader = EventStore::Client::HTTP::Vertx::Reader.build stream_name

slice_number = 0

Vertx.set_timer(60 * 1000 * 2) do
  reader.each do |slice|
    slice_number += 1
    logger(__FILE__).info "== BEGIN SLICE =="
    logger(__FILE__).info "Slice number: #{slice_number}"

    first_entry_id = slice.data['entries'][0]['id'] rescue "(none)"
    logger(__FILE__).info "First entry ID: #{first_entry_id}"

    number_of_entries = slice.data['entries'].length
    logger(__FILE__).info "Slice entries: #{number_of_entries}"

    logger(__FILE__).info "== END SLICE =="
  end
end
